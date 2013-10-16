//
// FCTextFilterer.h
//
// Created by worakarn isaratham on 10/9/13.
// Copyright (c) 2013 Worakarn Isaratham. All rights reserved.
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

//text items must conform to this protocol
@protocol FCTextFiltererItemDelegate <NSObject>

//unique identifier
-(id) key;

//text to be used in filtering
-(NSString *) searchText;

@end

//adopt this protocol to provide text items source
@protocol FCTextFiltererDelegate <NSObject>

//provide an NSArray of text items
-(NSArray *) reloadSource;

@end

@interface FCTextFilterer : NSObject

@property (strong, nonatomic) id<FCTextFiltererDelegate> delegate;

//reprocess using current filter
-(NSArray *) resultByReprocessFilter;

//filter by the given string
-(NSArray *) resultByFilterText:(NSString *) newFilter;

//returns the current filter
-(NSString *) currentFilter;

//(re)load items into the filterer using delegate's reloadSource
-(void) reload;

@end
