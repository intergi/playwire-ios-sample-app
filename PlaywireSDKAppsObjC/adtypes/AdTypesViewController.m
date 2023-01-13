//
//  AdTypesViewController.m
//  PlaywireDemo
//
//  Created by Playwire Mobile Team on 01/05/23.
//  Copyright © 2023 Playwire. All rights reserved.
//

#import "AdTypesViewController.h"
#import <Playwire-Swift.h>
#import "AdUnitViewControllerType.h"

@interface AdUnit: NSObject
@property (nonatomic, copy) NSString *mode;
@property (nonatomic, copy) NSString *name;
@end

@implementation AdUnit
@end

@interface AdTypesViewController() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<AdUnit *> *adUnits;
@end

@implementation AdTypesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    [self configureTitle];
    
    #if DEBUG
        // Start `PWNotifier` to log SDK events to console.
        [PWNotifier.shared startConsoleLogger];
    #endif
    
    __weak typeof(self) wself = self;
    // Initialize Playwire SDK with `publisherId` and `appId`, when initialization done, you will be able to load ad units.
    // Make sure you run SDK initialization only once.
    [PlaywireSDK.shared initializeWithPublisherId:@"playwire"
                                            appId:@"test"
                                   viewController:self
                                completionHandler:^() {
        [wself configureAdUnits];
        wself.tableView.backgroundView = NULL;
        [wself.tableView reloadData];
    }];
}

- (void)configureAdUnits {
    NSMutableArray<AdUnit *> *adUnits = [[NSMutableArray alloc] init];
    [PlaywireSDK.shared.adUnitsDictionary
     enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key,
                                         NSArray <NSString *> * _Nonnull values,
                                         BOOL * _Nonnull stop) {
        for (NSString *value in values) {
            AdUnit *adUnit = [AdUnit new];
            adUnit.name = value;
            adUnit.mode = key;
            [adUnits addObject:adUnit];
        }
    }];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"name" ascending: YES];
    self.adUnits = [adUnits sortedArrayUsingDescriptors: @[sortDescriptor]];
}

- (void)configureTitle {
    #if COPPA_APP
        self.title = @"Playwire Demo COPPA";
    #else
        self.title = @"Playwire Demo";
    #endif
}

- (void)configureTableView {
    UILabel *statusLabel = [UILabel new];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.text = @"⏳ SDK initializaton..";
    self.tableView.backgroundView = statusLabel;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AdUnit *adUnit = (AdUnit *)sender;
    id<AdUnitViewControllerType> destination = [segue destinationViewController];
    destination.adUnitName = adUnit.name;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdTypeCell" forIndexPath:indexPath];
    AdUnit *adUnit = self.adUnits[indexPath.row];
    
    UIListContentConfiguration *config = [UIListContentConfiguration subtitleCellConfiguration];
    config.text = adUnit.name;
    config.secondaryText = adUnit.mode;
    
    cell.contentConfiguration = config;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.adUnits.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AdUnit *adUnit = [self.adUnits objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:adUnit.mode sender:adUnit];
}

@end
