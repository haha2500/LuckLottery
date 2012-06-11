//
//  QCBallImageView.h
//  LuckLottery
//
//  Created by 武 孙 on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCBallImageView : UIView
{
    UIImage *_imageBall;
    Byte _btValue;
}

- (void)setType:(Byte)type andValue:(Byte)value;

@end
