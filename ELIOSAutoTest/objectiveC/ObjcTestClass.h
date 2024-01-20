//
//  ObjcTestClass.h
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 15.07.2022.
//

#ifndef ObjcTestClass_h
#define ObjcTestClass_h


#import <Foundation/Foundation.h>

@interface ObjcTestClass : NSObject

@property(nonatomic, strong) NSString *string;

+ (NSArray *)start:(id)obj;

@end

#endif /* ObjcTestClass */


