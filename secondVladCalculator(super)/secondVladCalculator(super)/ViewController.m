//
//  ViewController.m
//  SuperVladCalculator
//
//  Created by hyperactive on 02/04/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

#import "ViewController.h"
#import "customButton.h"

@interface ViewController ()

@property (nonatomic) BOOL isNewDisplay;
@property (nonatomic) BOOL isFakeClickSuspected;
@property (nonatomic) BOOL startPrecidenceOperation;
@property (nonatomic) BOOL finishedCalculation;
@property (nonatomic) BOOL isSmallAction;
@property (nonatomic) BOOL isNumberSaved;

@property (nonatomic) NSArray *operators;
@property (nonatomic) double number1;
@property (nonatomic) double number2;
@property (nonatomic) double result;
@property (nonatomic) double numberInMemory;
@property (nonatomic) int lastOperator;//2:+   3:-   4:*   5:/
@property (nonatomic) int operatorInMemory;//2:+   3:-   4:*   5:/

@property (weak, nonatomic) IBOutlet UILabel *displayLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _operators = @[_divisionButton,_multipleButton,_additionButton,_substractionButton];
    
    self.displayLabel.text = @"0";
}

//buttons action

- (IBAction)oneBtn:(id)sender
{
    [self displayAddNumber:@"1"];
    [self AC_CButtonChange:@"C"];
}

- (IBAction)twoBtn:(id)sender
{
    [self displayAddNumber:@"2"];
    [self AC_CButtonChange:@"C"];
}

- (IBAction)threeBtn:(id)sender
{
    [self displayAddNumber:@"3"];
    [self AC_CButtonChange:@"C"];
}

- (IBAction)fourBtn:(id)sender
{
    [self displayAddNumber:@"4"];
    [self AC_CButtonChange:@"C"];
}

- (IBAction)fiveBtn:(id)sender
{
    [self displayAddNumber:@"5"];
    [self AC_CButtonChange:@"C"];
}

- (IBAction)sixBtn:(id)sender
{
    [self displayAddNumber:@"6"];
    [self AC_CButtonChange:@"C"];
}

- (IBAction)sevenBtn:(id)sender
{
    [self displayAddNumber:@"7"];
    [self AC_CButtonChange:@"C"];
}

- (IBAction)eightBtn:(id)sender
{
    [self displayAddNumber:@"8"];
    [self AC_CButtonChange:@"C"];
}

- (IBAction)nineBtn:(id)sender
{
    [self displayAddNumber:@"9"];
    [self AC_CButtonChange:@"C"];
}

- (IBAction)zeroBtn:(id)sender
{
    [self displayAddNumber:@"0"];
    [self AC_CButtonChange:@"C"];
}

- (IBAction)plusBtn:(id)sender
{
    [self lowerPrecidenceOperator:2];
    [self removeAllBorders];
    [sender changeOperatorBorder];
}

- (IBAction)minusBtn:(id)sender
{
    [self lowerPrecidenceOperator:3];
    [self removeAllBorders];
    [sender changeOperatorBorder];
}

- (IBAction)multiplyButton:(id)sender
{
    [self higherPrecidenceOperator:4];
    [self removeAllBorders];
    [sender changeOperatorBorder];
}

- (IBAction)divisionButton:(id)sender
{
    [self higherPrecidenceOperator:5];
    [self removeAllBorders];
    [sender changeOperatorBorder];
}

- (IBAction)equalsBtn:(id)sender
{
    [self saveNumber];
    [self insideEqualsAction];
    [self endEquals];
}

- (IBAction)AC_CButton:(id)sender
{
    [self AC_CButtonChange:@"AC"];
    //in case % or negation are pressed without a result
    //so the display doesnt change the number
    if(_isSmallAction && !_finishedCalculation )
    {
        _isSmallAction = NO;
        return;
    }
    //saving the number that i have
    if(_finishedCalculation)
    {
        [self ACButtonSaveNumberAction];
        return;
    }
    [self ACButtonInsideAction];
}

- (IBAction)negationButton:(id)sender
{
    double num = [self.displayLabel.text doubleValue];
    _result = num == 0 ? num : -num;
    [self showResultOnDisplay];
    _isSmallAction = YES;
}

- (IBAction)percentageAction:(id)sender
{
    double num = [self.displayLabel.text doubleValue];
    _result = num / 100;
    [self showResultOnDisplay];
}

- (IBAction)decimalPoinButton:(id)sender
{
    if(![self hasDecimalPoint])
        [self displayAddNumber:@"."];
    else return;
}

//end of button action

-(void)endEquals
{
    _operatorInMemory = _lastOperator == 0 ? _operatorInMemory : _lastOperator;
    _lastOperator = 0;
    [self removeAllBorders];
}

-(void)precidenceOperation
{
    [self calculation];
    _lastOperator = _operatorInMemory;
    _number1 = _result;
    _result = _numberInMemory;
    [self calculation];
    _startPrecidenceOperation = NO;
}

-(void)calculation
{
    [self inCalculationAction:_lastOperator];
    [self rearangeNumbers];
}

-(void)inCalculationAction:(int)lastOperator
{
    int a = lastOperator;
    if(a == 2)
        _result = (_result == 0  || _number2 != 0) ? _number1 + _number2 : _result + _number1;
    else if(a == 3)
        _result = (_result == 0  || _number2 != 0) ? _number1 - _number2 : _result - _number1;
    else if(a == 4)
        _result = (_result == 0  || _number2 != 0) ? _number1 * _number2 : _result * _number1;
    else if(a == 5)
        _result = (_result == 0  || _number2 != 0) ? _number1 / _number2 : _result / _number1;
}


-(void)rearangeNumbers
{
    _numberInMemory = _startPrecidenceOperation ? _numberInMemory : (_number2 == 0 ? _number1 : _number2);
    _number1 = 0;
    _number2 = 0;
}

-(void)higherPrecidenceOperator:(int)operatorNumber
{
    if([self isFakeClickSetOperator:operatorNumber])
        return;
    [self saveNumber];
    if((_lastOperator == 2 || _lastOperator == 3) && _number1 != 0 && (_number2 != 0 || _result != 0))
    {
        [self inHigherPrecidenceOperationInitPrecidence:operatorNumber];
        return;
    }
    else if(_lastOperator == 4 || _lastOperator == 5)
            [self calculation];
    [self endOfOperator:operatorNumber];
}

-(void)lowerPrecidenceOperator:(int)operatorNumber
{
    if([self isFakeClickSetOperator:operatorNumber])
        return;
    
    [self saveNumber];
    if(_number1 != 0 && (_number2 != 0 || _result != 0) && _lastOperator != 0)
       [self calculation];
    [self endOfOperator:operatorNumber];
}

-(void)inHigherPrecidenceOperationInitPrecidence:(int)operatorNumber
{
    _startPrecidenceOperation = YES;
    _numberInMemory = _result == 0 ? _number1 : _result;
    _number1 = _number2 == 0 ? _number1 : _number2;
    _number2 = 0;
    _operatorInMemory = _lastOperator;
    [self endOfOperator:operatorNumber];
}

-(void)equalsPressedAfterNumber
{
    // 5 + 6 = 6 =
    _number1 = [self.displayLabel.text doubleValue];
    //placement of arguments matters
    [self specialOperation:&_numberInMemory and:&_number1];
    _result = _result == 0 ? _number1 : _result;
}

-(void)equalsPressedOperateWithDisplayNumber
{
    //6 + 5 = + = make the action with previous number
    double num = [self.displayLabel.text doubleValue];
    _result = num == 0 ? _numberInMemory : num;
    _number1 = _result;
    //placement of arguments matters
    [self specialOperation:&_result and:&_result];
    _number2 = 0;
    _isFakeClickSuspected = NO;
    [self rearangeNumbers];
}

-(void)equalsPressedAfterFinishedExpression
{
    //6 + 5 = =
    //placement of arguments matters
    double num = [self.displayLabel.text doubleValue];
    _number1 = num == 0 ? _numberInMemory : num;
    [self specialOperation:&_number1 and:&_numberInMemory];
    _number1 = 0;
}

-(void)specialOperation:(double*)n1 and:(double*)n2
{
    //the placement of operands matters
    int a = _lastOperator == 0 ? _operatorInMemory : _lastOperator;
    if(a == 2)
        _result =  *n1 + *n2;
    else if(a == 3)
        _result =  *n1 - *n2;
    else if(a == 4)
        _result =  *n1 * *n2;
    else if(a == 5)
        _result =  *n1 / *n2;
}

-(void)insideEqualsAction
{
    if(_isNumberSaved)
        _isNumberSaved = NO;
    else if(!_isFakeClickSuspected && !_isNewDisplay && _lastOperator == 0 && _number2 == 0)
        [self equalsPressedAfterNumber];
    else if (!_isFakeClickSuspected && _isNewDisplay && _lastOperator == 0 && _number2 == 0)
        [self equalsPressedAfterFinishedExpression];
    else if (_isFakeClickSuspected && _isNewDisplay && _lastOperator != 0 && _number2 == 0)
        [self equalsPressedOperateWithDisplayNumber];
    else if(_startPrecidenceOperation)
        [self precidenceOperation];
    else
        [self calculation];
    [self showResultOnDisplay];
}

-(void)endOfOperator:(int)operatorNumber
{
    _isFakeClickSuspected = YES;
    _isNewDisplay = YES;
    _lastOperator = operatorNumber;
    _isNumberSaved = NO;
}

-(BOOL)isFakeClickSetOperator:(int)operatorNumber
{
    if(_isFakeClickSuspected)
    {
        _lastOperator = operatorNumber;
        _operatorInMemory = 0;
        return true;
    }
    else return false;
}

-(void)showResultOnDisplay
{
    double num = _result == 0 ? _number1 : _result;
    self.displayLabel.text = [NSString stringWithFormat:@"%g",num];
    _isNewDisplay = YES;
    _isSmallAction = NO;
    _isNumberSaved = NO;
    _finishedCalculation = YES;
}

-(void)restartDisplay
{
    self.displayLabel.text = @"0";
    _isNewDisplay = NO;
    _isFakeClickSuspected = NO;
}

-(void)displayAddNumber:(NSString *)buttonNumber
{
    if(_isNewDisplay)
        [self restartDisplay];
    if([buttonNumber isEqualToString:@"."])
        self.displayLabel.text = [self.displayLabel.text stringByAppendingFormat:@"%@", buttonNumber];
    else
        self.displayLabel.text = [([self.displayLabel.text isEqualToString:@"0"] ? @"": self.displayLabel.text) stringByAppendingString:buttonNumber];
    _isFakeClickSuspected = NO;
    _isSmallAction = NO;
    _isNumberSaved = NO;
    _finishedCalculation = NO;
}

-(void)saveNumber
{
    if(_isNewDisplay)
        return;
    if(_number1 == 0)
        _number1 = [self.displayLabel.text doubleValue];
    else if(_number2 == 0)
        _number2 = [self.displayLabel.text doubleValue];
    _isNumberSaved = NO;
}

-(void)ACButtonSaveNumberAction
{
    if(_lastOperator != 0 || _operatorInMemory != 0)
    {
    _numberInMemory = [self.displayLabel.text doubleValue];
    _number1 = [self.displayLabel.text doubleValue];
    _number2 = 0;
    _finishedCalculation = NO;
    _isNumberSaved = YES;
    self.displayLabel.text = @"0";
    }
}

-(void)ACButtonInsideAction
{
    _number1 = 0;
    _number2 = 0;
    _result = 0;
    _numberInMemory = 0;
    _lastOperator = 0;
    _operatorInMemory = 0;
    _isSmallAction = NO;
    _isFakeClickSuspected = NO;
    _isNewDisplay = NO;
    _isNumberSaved = NO;
    _finishedCalculation = NO;
    _startPrecidenceOperation = NO;
    [self removeAllBorders];
    self.displayLabel.text = @"0";
}

-(void)AC_CButtonChange:(NSString *)title
{
    [UIView performWithoutAnimation:^{
      [self.ACButton setTitle:title forState:UIControlStateNormal];
      [self.ACButton layoutIfNeeded];
    }];
}

-(BOOL)hasDecimalPoint
{
    NSString *display = self.displayLabel.text;
    NSRange searchPoint = [display rangeOfString:@"."];
    [self AC_CButtonChange:@"C"];
    if(searchPoint.location == NSNotFound)
        return false;
    else return true;
}

-(void)removeAllBorders
{
    for(customButton *btn in _operators)
        [btn removeButtonBorder];
}

@end

