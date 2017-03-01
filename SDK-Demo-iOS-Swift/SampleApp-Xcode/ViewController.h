//
//  ViewController.h
//  SampleApp-Xcode
//
//  Created by Luu Lanh on 11/11/15.
//  Copyright © 2015 LuuLanh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface ViewController : UIViewController <ASIHTTPRequestDelegate,UITextFieldDelegate>

- (IBAction)pushNoti:(id)sender;
- (IBAction)cancelNoti:(id)sender;

@end

