//
//  FMSongData.h
//  DBFM
//
//  Created by chenzhipeng on 15/5/6.
//  Copyright (c) 2015年 chenzhipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMSongData : NSObject
@property (nonatomic, strong) NSString *m_aid;
@property (nonatomic, strong) NSString *m_album;
@property (nonatomic, strong) NSString *m_albumtitle;
@property (nonatomic, strong) NSString *m_artist;
@property (nonatomic, strong) NSString *m_company;
@property (nonatomic, strong) NSString *m_kbps;
@property (nonatomic, strong) NSString *m_length;
@property (nonatomic, strong) NSString *m_like;
@property (nonatomic, strong) NSString *m_picture;
@property (nonatomic, strong) NSString *m_public_time;
@property (nonatomic, strong) NSString *m_rating_avg;
@property (nonatomic, strong) NSString *m_sha256;
@property (nonatomic, strong) NSString *m_sid;
@property (nonatomic, strong) NSString *m_songlists_count;
@property (nonatomic, strong) NSString *m_ssid;
@property (nonatomic, strong) NSString *m_subtype;
@property (nonatomic, strong) NSString *m_title;
@property (nonatomic, strong) NSString *m_url;

-(void)parseDicToData:(NSDictionary *)dicData;
@end
