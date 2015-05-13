//
//  HttpController.h
//  DBFM
//
//  Created by chenzhipeng on 15/5/6.
//  Copyright (c) 2015年 chenzhipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@protocol HttpCtrDelegate <NSObject>

-(void)receiveResponseData:(id)data;

-(void)responseDidFailed;

@end
@interface HttpController : NSObject
@property (nonatomic, weak) id<HttpCtrDelegate> m_delegate;

-(void)requestJsonData:(NSString *)url;
-(NSData *)requestData:(NSString *)url;
@end
