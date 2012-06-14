//
//  QCBallImageView.h
//  LuckLottery
//
//  Created by 武 孙 on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义号码球类型
#define kBallTypeNormal             0X00        // 普通
#define kBallTypeMatch              0X01        // 中出
#define kBallTypeGold               0X02        // 金码
#define kBallTypeLT                 0X80        // 乐透型号码

@interface QCBallImageView : UIView
{
    Byte _btCount;          // 号码球个数，为0则表示需要开奖号
    Byte _btTypes[8];       // 每个号码球的类型，见宏定义，如：kBallTypeMatch
    Byte _btValues[8];      // 每个号码球的值
}

- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)addBall:(Byte)type andValue:(Byte)value;
- (void)removeAllBalls;

@end
