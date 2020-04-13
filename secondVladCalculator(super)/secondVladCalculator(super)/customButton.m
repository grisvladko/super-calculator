//
//  customButton.m
//  secondVladCalculator(super)
//
//  Created by hyperactive on 12/04/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

#import "customButton.h"
#import "ViewController.h"

@implementation customButton

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.layer.borderWidth = 0.7f;
    UIColor *borderColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    self.layer.borderColor = borderColor.CGColor;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self changeColor];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.backgroundColor = _BGColor;
    self.alpha = 1.0f;
}

-(void)changeColor
{
    NSString *label = [self accessibilityLabel];
    UIColor *myColor = [[UIColor alloc]init];
    _BGColor = self.backgroundColor;
    if([label isEqualToString:@"top"] || [label isEqualToString:@"AC"])
        myColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    else if([label isEqualToString:@"operator"])
    {
        self.alpha = 0.5f;
        self.titleLabel.alpha = 1.f;
        return;
    }
    else
        myColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
    
    self.backgroundColor = myColor;
}

-(void)initDefaultBorder
{
    self.layer.borderWidth = 0.7f;
    UIColor *borderColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    self.layer.borderColor = borderColor.CGColor;
}

-(void)removeButtonBorder
{
    [self initDefaultBorder];
}

-(void)changeOperatorBorder
{
    self.layer.borderWidth = 3.0f;
    UIColor *borderColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    self.layer.borderColor = borderColor.CGColor;
}
@end
