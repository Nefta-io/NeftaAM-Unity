#import "RewardedVideoNeftaRequest.h"

@implementation RewardedVideoNeftaRequest {
    __weak id<GADMediationRewardedAdEventDelegate> _adEventDelegate;
}

@synthesize _adapter;
@synthesize _placement;

+ (instancetype)Init:(NeftaAdapter *)adapter callback:(nonnull GADMediationRewardedLoadCompletionHandler)callback {
    RewardedVideoNeftaRequest *instance = [[self alloc] init];
    instance._adapter = adapter;
    instance.callback = callback;
    return instance;
}

- (void)presentFromViewController:(nonnull UIViewController *)viewController {
    if (![_adapter.Plugin IsReadyWithId: _placement._id]) {
        NSError *showError = [NSError errorWithDomain: _adapter.ErrorDomain
                                                 code: NeftaAdapterErrorCodeAdNotReady
                                             userInfo: @{NSLocalizedDescriptionKey : @"Ad not ready."}];
        [_adEventDelegate didFailToPresentWithError:showError];
        return;
    }

    [_adapter.Plugin PrepareRendererWithViewController: viewController];
    if (_muteAudio) {
        [_adapter.Plugin Mute: true];
    }
    [_adapter.Plugin ShowWithId: _placement._id];
}

- (void)OnLoadFail:(NSString *)error {
    _callback(nil, [NSError errorWithDomain: _adapter.ErrorDomain code: NeftaAdapterErrorCodeInvalidServerParameters userInfo: nil]);
}

- (void)OnLoad:(Placement *)placement {
    _placement = placement;
    _adEventDelegate = _callback(self, nil);
}

- (void)OnShow:(NSInteger)width height:(NSInteger)height {
    [_adEventDelegate willPresentFullScreenView];
}

- (void)OnClick {
    [_adEventDelegate reportClick];
}

- (void)OnRewarded {
    [_adEventDelegate didRewardUser];
}

- (void)OnClose {
    if (_muteAudio) {
        [_adapter.Plugin Mute: false];
    }
    [_adEventDelegate didDismissFullScreenView];
}

@end
