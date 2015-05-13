//
//  FMChannelData.h
//  DBFM
//
//  Created by chenzhipeng on 15/5/6.
//  Copyright (c) 2015年 chenzhipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMChannelData : NSObject
@property (nonatomic, strong) NSString *m_abbr_en;
@property (nonatomic, strong) NSString *m_channel_id;
@property (nonatomic, strong) NSString *m_name;
@property (nonatomic, strong) NSString *m_name_en;
@property (nonatomic) NSInteger m_seq_id;

-(void)parseDicToData:(NSDictionary *)dicData;
@end
