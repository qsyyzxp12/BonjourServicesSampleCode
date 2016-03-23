//
//  ViewController.h
//  BonjourClient
//
//  Created by Lin Chih-An on 2016/3/22.
//  Copyright © 2016年 Lin Chih-An. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSNetServiceBrowserDelegate, NSNetServiceDelegate, NSStreamDelegate>
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}
@property (strong, nonatomic) NSNetServiceBrowser* browser;
@property (nonatomic, strong) NSNetService* netService;
@property BOOL count;
@end

