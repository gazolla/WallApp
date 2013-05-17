//
//  GzCell.m
//  TVCellCustom
//
//  Created by sebastiao Gazolla Costa Junior on 22/02/12.
//  Copyright (c) 2012 iPhone and Java developer. All rights reserved.
//

#import "GzCell.h"

@implementation GzCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UACellBackgroundView alloc] initWithFrame:CGRectZero];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;	
}

- (void)setPosition:(UACellBackgroundViewPosition)newPosition {	
    [(UACellBackgroundView *)self.backgroundView setPosition:newPosition];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
