
#import "RNInMobiRewarded.h"

#if __has_include(<React/RCTUtils.h>)
#import <React/RCTUtils.h>
#else
#import "RCTUtils.h"
#endif

static NSString *const kEventAdLoaded = @"rewardedVideoAdLoaded";
static NSString *const kEventAdFailedToLoad = @"rewardedVideoAdFailedToLoad";
static NSString *const kEventAdOpened = @"rewardedVideoAdOpened";
static NSString *const kEventAdClosed = @"rewardedVideoAdClosed";
static NSString *const kEventRewarded = @"rewardedVideoAdRewarded";
static NSString *const kEventVideoStarted = @"rewardedVideoAdVideoStarted";
static NSString *const kEventVideoCompleted = @"rewardedVideoAdVideoCompleted";

@implementation RNInMobiRewarded
{
    NSString *_placementID;
    IMInterstitial *_interstitial;
    RCTPromiseResolveBlock _requestAdResolve;
    RCTPromiseRejectBlock _requestAdReject;
    BOOL hasListeners;
    BOOL isReady;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents
{
    return @[
             kEventRewarded,
             kEventAdLoaded,
             kEventAdFailedToLoad,
             kEventAdOpened,
             kEventVideoStarted,
             kEventAdClosed,
             kEventVideoCompleted ];
}

#pragma mark exported methods

RCT_EXPORT_METHOD(setPlacementID:(NSString *)placementID)
{
  _placementID = placementID;
}

RCT_EXPORT_METHOD(requestAd:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    _requestAdResolve = resolve;
    _requestAdReject = reject;

    if (_interstitial == nil) {
      _interstitial = [[IMInterstitial alloc] initWithPlacementId:_placementID];
      _interstitial.delegate = self;
    }

    isReady = NO;
    [_interstitial load];
}

RCT_EXPORT_METHOD(showAd:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    if (isReady) {
      [_interstitial showFromViewController:self];
      resolve(nil);
    }
    else {
      reject(@"E_AD_NOT_READY", @"Ad is not ready.", nil);
    }
}

RCT_EXPORT_METHOD(isReady:(RCTResponseSenderBlock)callback)
{
    callback(@[[NSNumber numberWithBool:isReady]]);
}

- (void)startObserving
{
    hasListeners = YES;
}

- (void)stopObserving
{
    hasListeners = NO;
}

#pragma mark AdDelegate

/*Indicates that the interstitial is ready to be shown */
- (void)interstitialDidFinishLoading:(IMInterstitial *)interstitial {
  isReady = YES;
  if (hasListeners) {
    [self sendEventWithName:kEventAdLoaded body:nil];
  }
  _requestAdResolve(nil);
}
/* Indicates that the interstitial has failed to receive an ad. */
- (void)interstitial:(IMInterstitial *)interstitial didFailToLoadWithError:(IMRequestStatus *)error {
    if (hasListeners) {
    NSDictionary *jsError = RCTJSErrorFromCodeMessageAndNSError(@"E_AD_FAILED_TO_LOAD", error.description, error);
    [self sendEventWithName:kEventAdFailedToLoad body:jsError];
  }
  
  _requestAdReject(@"E_AD_FAILED_TO_LOAD", error.description, error);
}
/* Indicates that the interstitial has failed to present itself. */
- (void)interstitial:(IMInterstitial *)interstitial didFailToPresentWithError:(IMRequestStatus *)error {
    NSLog(@"Interstitial didFailToPresentWithError");
    NSLog(@"Error : %@",error.description);
    isReady = NO;
}
/* indicates that the interstitial is going to present itself. */
- (void)interstitialWillPresent:(IMInterstitial *)interstitial {
  if (hasListeners) {
    [self sendEventWithName:kEventVideoStarted body:nil];
  }
}
/* Indicates that the interstitial has presented itself */
- (void)interstitialDidPresent:(IMInterstitial *)interstitial {
  if (hasListeners) {
    [self sendEventWithName:kEventAdOpened body:nil];
  }
}
/* Indicates that the interstitial is going to dismiss itself. */
- (void)interstitialWillDismiss:(IMInterstitial *)interstitial {
  NSLog(@"interstitialWillDismiss");
  if (hasListeners) {
    [self sendEventWithName:kEventVideoCompleted body:nil];
  }
}
/* Indicates that the interstitial has dismissed itself. */
- (void)interstitialDidDismiss:(IMInterstitial *)interstitial {
  if (hasListeners) {
    [self sendEventWithName:kEventAdClosed body:nil];
  }
}
/* Indicates that the user will leave the app. */
- (void)userWillLeaveApplicationFromInterstitial:(IMInterstitial *)interstitial {
    NSLog(@"userWillLeaveApplicationFromInterstitial");
}
/* Indicates that a reward action is completed */
- (void)interstitial:(IMInterstitial *)interstitial rewardActionCompletedWithRewards:(NSDictionary *)rewards {
    NSLog(@"rewardActionCompletedWithRewards");
    if (hasListeners) {
      [self sendEventWithName:kEventRewarded body:nil];
    }
}
/* interstitial:didInteractWithParams: Indicates that the interstitial was interacted with. */
- (void)interstitial:(IMInterstitial *)interstitial didInteractWithParams:(NSDictionary *)params {
    NSLog(@"InterstitialDidInteractWithParams");
}

/* Not used for direct integration. Notifies the delegate that the ad server has returned an ad but assets are not yet available. */
- (void)interstitialDidReceiveAd:(IMInterstitial *)interstitial {
}

@end
  
