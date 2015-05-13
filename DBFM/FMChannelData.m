//
//  FMChannelData.m
//  DBFM
//
//  Created by chenzhipeng on 15/5/6.
//  Copyright (c) 2015年 chenzhipeng. All rights reserved.
//

#import "FMChannelData.h"

@implementation FMChannelData
@synthesize m_abbr_en, m_channel_id, m_name, m_name_en, m_seq_id;

-(void)parseDicToData:(NSDictionary *)dicData
{
    m_abbr_en = [dicData valueForKey:@"abbr_en"];
    m_channel_id = [dicData valueForKey:@"channel_id"];
    m_name = [dicData valueForKey:@"name"];
    m_name_en = [dicData valueForKey:@"name_en"];
    m_seq_id = [[dicData valueForKey:@"seq_id"] integerValue];
}
@end
