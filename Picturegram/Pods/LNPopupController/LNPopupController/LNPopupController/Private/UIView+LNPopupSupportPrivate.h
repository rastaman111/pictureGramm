//
//  UIView+LNPopupSupportPrivate.h
//  LNPopupController
//
//  Created by Leo Natan on 8/1/20.
//  Copyright © 2015-2020 Leo Natan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LNInWindowBlock)(dispatch_block_t);

@interface UIView (LNPopupSupportPrivate)

- (void)_ln_letMeKnowWhenViewInWindowHierarchy:(LNInWindowBlock)block;
- (void)_ln_forgetAboutIt;
- (NSString*)_effectGroupingIdentifierIfAvailable;

@end

NS_ASSUME_NONNULL_END
