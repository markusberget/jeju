//
//  CommitBlock.h
//  jeju
//
//  Created by Davíð Arnarsson on 13/05/14.
//  Copyright (c) 2014 Markus Berget. All rights reserved.
//

#ifndef jeju_CommitBlock_h
#define jeju_CommitBlock_h
#include "Octokit.h" 

typedef void (^ ReturnBlock)(OCTGitCommit *);
typedef void (^ HandlingBlock)(id, int);


#endif
