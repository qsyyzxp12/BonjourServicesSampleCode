//
//  ViewController.h
//  BonjourServer
//
//  Created by Lin Chih-An on 2016/3/22.
//  Copyright © 2016年 Lin Chih-An. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController <NSNetServiceDelegate, NSStreamDelegate>
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}
@property (strong, nonatomic) NSNetService* service;
@property BOOL count;
@end

