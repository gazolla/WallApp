//
//  UACellBackgroundView.h
//  TravelExp004
//
//  Created by sebastiao Gazolla Costa Junior on 22/02/12.
//  Copyright (c) 2012 iPhone and Java developer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    UACellBackgroundViewPositionSingle = 0,
    UACellBackgroundViewPositionTop, 
    UACellBackgroundViewPositionBottom,
    UACellBackgroundViewPositionMiddle
} UACellBackgroundViewPosition;

@interface UACellBackgroundView : UIView {
    UACellBackgroundViewPosition position;
}

@property(nonatomic) UACellBackgroundViewPosition position;

@end
