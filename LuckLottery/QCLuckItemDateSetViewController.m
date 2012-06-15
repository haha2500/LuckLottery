//
//  QCLuckItemDateSetViewController.m
//  LuckLottery
//
//  Created by 武 孙 on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QCLuckItemDateSetViewController.h"

@interface QCLuckItemDateSetViewController ()

@end

@implementation QCLuckItemDateSetViewController
@synthesize luckItem;
@synthesize datePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"幸运日设置";
    
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    [dateComp setYear:(luckItem.nValue / 10000)];
    [dateComp setMonth:((luckItem.nValue / 100) % 100)];
    [dateComp setDay:(luckItem.nValue % 100)];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    [datePicker setDate:[calendar dateFromComponents:dateComp]];
}

- (void)viewDidUnload
{
    [self setDatePicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[datePicker date]];
    luckItem.nValue = [dateComp year] * 10000 + [dateComp month] * 100 + [dateComp day];
    luckItem.strValue = [NSString stringWithFormat:@"当前设置：%04d年%02d月%02d日", [dateComp year], [dateComp month], [dateComp day]];
    
    luckItem.bModified = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
