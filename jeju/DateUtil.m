//
//  DateUtil.m
//  jeju
//
//  Created by Joel Lundell on 4/9/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil



+(NSString *)formatDate:(NSDate *) date WithFormat:(NSString *) format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+(NSString *)getISODate:(NSDate *) date
{
    return [DateUtil formatDate:date WithFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
}
@end
