//
//  ViewController.h
//  SuperVladCalculator
//
//  Created by hyperactive on 02/04/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customButton.h"
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet customButton *ACButton;
@property (weak, nonatomic) IBOutlet customButton *divisionButton;
@property (weak, nonatomic) IBOutlet customButton *multipleButton;
@property (weak, nonatomic) IBOutlet customButton *substractionButton;
@property (weak, nonatomic) IBOutlet customButton *additionButton;

@end

