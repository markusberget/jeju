//
//  DateUtil.h
//  jeju
//
//  Created by Joel Lundell on 4/9/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject


+(NSString *) formatDate:(NSDate *) date WithFormat:(NSString *)format;

@end
