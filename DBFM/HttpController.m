//
//  HttpController.m
//  DBFM
//
//  Created by chenzhipeng on 15/5/6.
//  Copyright (c) 2015年 chenzhipeng. All rights reserved.
//

#import "HttpController.h"

@implementation HttpController
@synthesize m_delegate;

// 异步请求
-(void)requestJsonData:(NSString *)url
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //注意：默认的Response为json数据
    /**
     AFXMLParserResponseSerializer -> XML
     AFHTTPResponseSerializer      -> NSData
     AFJSONResponseSerializer      -> JSON
     **/
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //注意：此行不加也可以
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain; charset=utf-8"];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    
    //SEND YOUR REQUEST
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if(m_delegate && [m_delegate respondsToSelector:@selector(receiveResponseData:)])
        {
            [m_delegate receiveResponseData:responseObject];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [m_delegate responseDidFailed];
    }];
}

// 同步请求
-(NSData *)requestData:(NSString *)url
{
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [requestOperation setResponseSerializer:responseSerializer];
        [requestOperation start];
        [requestOperation waitUntilFinished];
        
        NSData *data = [requestOperation responseObject];
        return data;

}

@end
