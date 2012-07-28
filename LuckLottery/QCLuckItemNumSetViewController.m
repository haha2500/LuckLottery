//
//  QCLuckItemNumSetViewController.m
//  LuckLottery
//
//  Created by 武 孙 on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QCLuckItemNumSetViewController.h"

@interface QCLuckItemNumSetViewController ()

@end

@implementation QCLuckItemNumSetViewController
@synthesize luckItem, numPicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        numbersArray = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    numPicker.delegate = self;
    int nValue = luckItem.nValue;
    for (int i=7; i>=0; i--)
    {
        [numPicker selectRow:500 + (nValue % 10) inComponent:i animated:NO];
        nValue /= 10;
    }
    
    [[self navigationItem] setTitle:@"幸运数字设置"];
}

- (void)viewDidUnload
{
    [self setNumPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    int nValue = 0;
    for (int i=0; i<8; i++)
    {
        nValue *= 10;
        nValue += ([numPicker selectedRowInComponent:i] % 10);
    }
    luckItem.nValue = nValue;
    luckItem.strValue = [NSString stringWithFormat:@"当前设置：%d", nValue];
    
    luckItem.bModified = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
    {
        return YES;
    }
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 8;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 1000;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [numbersArray objectAtIndex:row % 10];
}
@end
