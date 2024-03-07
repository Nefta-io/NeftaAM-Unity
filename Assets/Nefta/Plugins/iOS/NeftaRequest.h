#import <Foundation/Foundation.h>
#import "NeftaAdapter.h"
#import <NeftaSDK/NeftaSDK-Swift.h>

@protocol NeftaRequest <NSObject>

@property NeftaAdapter *_adapter;
@property Placement *_placement;

- (void) OnLoadFail: (NSString *) error;
- (void) OnLoad: (Placement *)placement;
- (void) OnShow: (NSInteger)width height:(NSInteger)height;
- (void) OnClick;
- (void) OnRewarded;
- (void) OnClose;

@end
