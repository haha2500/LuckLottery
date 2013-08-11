//
//  QCLoginView.m
//  LuckLottery
//
//  Created by 孙武 on 12-12-10.
//
//

#import "QCLoginView.h"

@implementation QCLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 登录服务器
        // Initialization code
        
        NSString *strSoftVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        NSString *strOSName = [NSString stringWithFormat:@"%@ %@", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
        NSString *strIMEI = @"IMEI";
        NSString *strDeviceType = [[UIDevice currentDevice] localizedModel];
        NSInteger width = [[UIScreen mainScreen] bounds].size.width * [UIScreen mainScreen].scale;
        NSInteger height = [[UIScreen mainScreen] bounds].size.height * [UIScreen mainScreen].scale;
        NSInteger loginID = [[NSUserDefaults standardUserDefaults] integerForKey:@"LoginID"];
        NSString *strURLLogin = [[NSString stringWithFormat:@"%@login_IOS.asp?ID=%d&SoftID=1&SoftVer=%@&OSType=1&OSName=IOS_%@&CX=%d&CY=%d&IMEI=%@&DeviceType=%@", kBASEURL, loginID, strSoftVer, strOSName, width, height, strIMEI, strDeviceType] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSURL *url = [NSURL URLWithString:strURLLogin];
        NSURLRequest *requset = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        downloadData = [[NSMutableData alloc] init];
        
        connection = [[NSURLConnection alloc] initWithRequest:requset delegate:self startImmediately:YES];
    }
    return self;
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [downloadData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    int nBufLen = [downloadData length];
    char *lpBuf = (char *)[downloadData bytes], szID[32] = {0};
    if (!memcmp(lpBuf, "ID=", 3) && nBufLen < 13) {  // 登录成功，则保存ID号
        memcpy(szID, &lpBuf[3], nBufLen - 3);
        [[NSUserDefaults standardUserDefaults] setInteger:atoi(szID) forKey:@"LoginID"];
    }
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
