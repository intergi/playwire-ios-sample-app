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
@import FirebaseCore;

@interface AdUnit: NSObject
@property (nonatomic, copy) NSString *mode;
@property (nonatomic, copy) NSString *name;
@end

@implementation AdUnit
@end

@interface AdTypesViewController() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<AdUnit *> *adUnits;
@property (strong, nonatomic) PWListenerToken *interstitialListener;
@end

@implementation AdTypesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    [self configureTitle];
    
    #if DEBUG
        // Start `PWNotifier` to log SDK events to console.
        [PWNotifier.shared startConsoleLogger];
    
        // Use method below to filter SDK events by name or severity
        // Filter and log only events with `PWC.EVT_gamRequestFail` name
        // [[PWNotifier shared] startConsoleLoggerWithFilter:^BOOL(NSString * _Nonnull event, BOOL critical, NSDictionary<NSString *,id> * _Nonnull context) {
        //    return [event isEqualToString:PWC.EVT_gamRequestFail];
        // }];
        // Filter and log only critical events
        // [[PWNotifier shared] startConsoleLoggerWithFilter:^BOOL(NSString * _Nonnull event, BOOL critical, NSDictionary<NSString *,id> * _Nonnull context) {
        //    return critical;
        // }];
    
        // Use a custom-made listener to handle events with custom actions.
        // You can cancel subscription once it's not needed. For example, in the `viewWillDisappear` method.
        //
        // In the example below we create a subscription to listen to all successful interstitial loading events
        self.interstitialListener = [[PWNotifier shared] addListener:self filter:^BOOL(NSString * _Nonnull event, BOOL critical, NSDictionary<NSString *,id> * _Nonnull context) {
            return [event isEqualToString:PWC.EVT_gamRequestSuccess] && [(NSString *)context[PWC.EVT_CTX_adUnit_mode] isEqualToString:PWAdUnit.PWAdMode_Interstitial];
        } action:^(id _Nonnull listenr, NSString * _Nonnull event, BOOL critical, NSDictionary<NSString *,id> * _Nonnull context, NSDictionary<NSString *,id> * _Nonnull data) {
            // Use event data regarding your business objectives, e.g, send analytics record, etc.
        }];
    #endif
    
    // If you use Firebase, don't forget to configure Firebase application.
    // Make sure you run it before Playwire SDK initialization.
    //
    // [FIRApp configure];
    
    #if DEBUG
        // Enable test mode for debug builds to avoid `no fill` issues and be able to test your implementation with test ads.
        [PlaywireSDK.shared setTest:YES];
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

- (void)viewWillDisappear:(BOOL)animated {
    // Cancel subscription once it's not needed.
    [self.interstitialListener cancel];
    self.interstitialListener = NULL;
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
    if ([segue.identifier isEqualToString:@"BannerLayout"]) return;
    
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
    
    // Show predefined view controller with banners that created in the storyboard
    if ([adUnit.name isEqualToString:@"Banner-320x50"]) {
        [self performSegueWithIdentifier:@"BannerLayout" sender:adUnit];
        return;
    }
    
    [self performSegueWithIdentifier:adUnit.mode sender:adUnit];
}

@end
