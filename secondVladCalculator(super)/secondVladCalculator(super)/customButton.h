//
//  customButton.h
//  secondVladCalculator(super)
//
//  Created by hyperactive on 12/04/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface customButton : UIButton
@property (nonatomic) UIColor *BGColor;
@property (nonatomic) BOOL isOperatorBorderChanged;
-(void)changeOperatorBorder;
-(void)removeButtonBorder;
@end

NS_ASSUME_NONNULL_END
