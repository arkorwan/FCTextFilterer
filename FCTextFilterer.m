//
// FCTextFilterer.m
//
// Created by worakarn isaratham on 10/9/13.
//
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

#import "FCTextFilterer.h"
#import "NSString+StringProcessing.h"

@implementation FCTextFilterer{
    
    NSArray *allData;
    NSString *filterText;
    NSMutableDictionary *searchTextMap;
    NSMutableDictionary *searchResultStack;
    BOOL shouldReload;
}


- (instancetype) init
{
    if(self = [super init]){
        searchTextMap = [NSMutableDictionary new];
        searchResultStack = [NSMutableDictionary new];
        self.comparisonMask = NSCaseInsensitiveSearch;
        [self reload];
        filterText = @"";
        shouldReload = YES;
    }
    return self;
}

-(void) reload
{
    allData = [self.delegate itemsForTextFilterer:self];
    [searchTextMap removeAllObjects];
    for(id<FCTextFiltererItemDelegate> item in allData){
        searchTextMap[[item key]] = [item searchText];
    }
    [searchResultStack removeAllObjects];
    shouldReload = NO;
}

-(void) loadIfNeeded
{
    if(shouldReload) [self reload];
}

-(void) shouldReloadItems
{
    shouldReload = YES;
}

-(NSString *) currentFilter
{
    return filterText;
}

-(NSArray *) resultByReprocessFilter
{
	[self loadIfNeeded];
    //clear cache here
    [searchResultStack removeAllObjects];
    return [self resultByProcessFilterFromScratch:filterText];
}

-(BOOL) isItem:(id<FCTextFiltererItemDelegate>) item containsString:(NSString *) filter
{
    return [searchTextMap[[item key]] containsString:filter options:self.comparisonMask];
}

-(NSArray *) resultByProcessFilterFromScratch:(NSString *) filter
{
    //process each word separately
    NSArray *words = [filter splitByWhitespace];
    
    NSMutableArray *searchResult = [NSMutableArray new];
    for(id<FCTextFiltererItemDelegate> item in allData){
        BOOL okay = YES;
        for(NSString *word in words){
            okay = [self isItem:item containsString:word];
            if(!okay) break;
        }
        if(okay){
            [searchResult addObject:item];
        }
    }
    
    NSArray *result = [NSArray arrayWithArray:searchResult];
    searchResultStack[filter] = result;
    return result;
}

-(NSArray *) resultByFilterText:(NSString *) newFilter
{
    return [self resultByFilterText:newFilter saveFilter:YES];
}


-(NSArray *) resultByFilterText:(NSString *) newFilter saveFilter:(BOOL) save
{
	[self loadIfNeeded];
    newFilter = [[newFilter lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray *cachedResult = [searchResultStack objectForKey:newFilter];
    NSArray *result;
    if(cachedResult){
        //Case 1: has cached result
        result = cachedResult;
        
    } else if([newFilter length] == 0){
        //Case 2: empty/clear filter
        result = @[];
        //clear cache here
        [searchResultStack removeAllObjects];
        
    } else if([filterText length] == 0 ){
        //Case 3: first time filter (previous filter was empty)
        result = [self resultByProcessFilterFromScratch:newFilter];
        
    } else if ([newFilter hasPrefix:filterText] && newFilter.length > filterText.length){
        //Case 4: new filter is by appending to old filter
        NSMutableArray *searchResult = [NSMutableArray new];
        for(id<FCTextFiltererItemDelegate> item in [self resultByFilterText:filterText saveFilter:NO]){
            //use only last word
            NSArray *words = [newFilter splitByWhitespace];
            NSString *lastWord = [words lastObject];
            if([self isItem:item containsString:lastWord]){
                [searchResult addObject:item];
            }
        }
        result = [NSArray arrayWithArray:searchResult];
        searchResultStack[newFilter] = result;
    } else {
        //for other cases, revert to first time filter
        result = [self resultByProcessFilterFromScratch:newFilter];
    }
    
    if(save){
        filterText = newFilter;
    }
    
    return result;
}

@end
