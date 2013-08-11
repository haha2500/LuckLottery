//
//  QCLoginView.h
//  LuckLottery
//
//  Created by 孙武 on 12-12-10.
//
//

#import <UIKit/UIKit.h>

#ifdef DEBUG  // 调试版
    #define kBASEURL @"http://software.pinble.com/mobile/debug/"
#else
    #define kBASEURL @"http://software.pinble.com/mobile/release/"
#endif

@interface QCLoginView : UIView
{
    NSURLConnection *connection;    
    NSMutableData *downloadData;
}
@end
