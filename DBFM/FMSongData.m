//
//  FMSongData.m
//  DBFM
//
//  Created by chenzhipeng on 15/5/6.
//  Copyright (c) 2015年 chenzhipeng. All rights reserved.
//

#import "FMSongData.h"

@implementation FMSongData
@synthesize m_aid, m_album, m_albumtitle, m_artist, m_company, m_kbps, m_length, m_like, m_picture, m_public_time, m_rating_avg, m_sha256, m_sid, m_songlists_count, m_ssid, m_subtype, m_title, m_url;

-(void)parseDicToData:(NSDictionary *)dicData
{
    m_aid = [dicData valueForKey:@"aid"];
    m_album = [dicData valueForKey:@"album"];
    m_albumtitle = [dicData valueForKey:@"albumtitle"];
    m_artist = [dicData valueForKey:@"artist"];
    m_company = [dicData valueForKey:@"company"];
    m_kbps = [dicData valueForKey:@"kbps"];
    m_length = [dicData valueForKey:@"length"];
    m_like = [dicData valueForKey:@"like"];
    m_picture = [dicData valueForKey:@"picture"];
    m_public_time = [dicData valueForKey:@"public_time"];
    m_rating_avg = [dicData valueForKey:@"rating_avg"];
    m_sha256 = [dicData valueForKey:@"sha256"];
    m_sid = [dicData valueForKey:@"sid"];
    m_songlists_count = [dicData valueForKey:@"songlists_count"];
    m_ssid = [dicData valueForKey:@"ssid"];
    m_subtype = [dicData valueForKey:@"subtype"];
    m_title = [dicData valueForKey:@"title"];
    m_url = [dicData valueForKey:@"url"];

}
@end
