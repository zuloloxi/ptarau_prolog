scripts:-
  foreach(
   member(S,[
    bline,
    pr,
    lesk,
    pr_lesk,
    freq,
    pr_freq,
    lesk_frq,
    best
   ]),
   call(S)
  ).  
    
bline:- % 35p
  clear_params,
  set_param(logfile,'shuffled_baseline.txt'),   
  set_param(shuffle,yes),    % removes order bias coming from decreasing WNet Freq order
  set_param(freq_rank,no), % combines PR rank with WNet Freq info
  set_param(rank,no),      % activates PageRank
  set_param(maxsyn,64),     % only takes first maxsyn synsets in decr. WNet Freq order
  set_param(links,no),     % adds to the PR graph links based on Rel-related synsets
  set_param(rel,xfail),   % specifies Rel - xlinked means any sense discriminating Rel
  set_param(lesk,no),      % activates Lesk ordering - after shuffle
  set_param(freq_lesk,no), % if Lesk of a synset=0 than take most freq WNet sense
  set_param(glinks,no),     % adds to the PR graph links from glosses
  set_param(freq_links,no), % adds links from less freq to more freq synsets
  set_param(sem_links,no),  % adds links based on various sem. Rels between synsets in the text
  set_param(co_occ,no),     % adds links for words co-occuring in a small window in a sentence
  set_param(rank_order,no), % orders synsets by their Global WordNet Rank - not very useful
  set_param(random_seed,99),% sets random seed: use 'no' for sys. provided seed
  dis,
  endlog.

% SHUFFLED ALGORITHMS

pr:- % 43p
  clear_params,
  set_param(logfile,'shuffled_pr.txt'),   
  set_param(shuffle,yes),   % removes order bias coming from decreasing WNet Freq order
  set_param(freq_rank,no),  % combines PR rank with WNet Freq info
  set_param(rank,yes),      % activates PageRank
  set_param(maxsyn,64),     % only takes first maxsyn synsets in decr. WNet Freq order
  set_param(links,yes),     % adds to the PR graph links based on Rel-related synsets
  set_param(rel,xlinked),   % specifies Rel - xlinked means any sense discriminating Rel
  set_param(lesk,no),       % activates Lesk ordering - after shuffle
  set_param(freq_lesk,no),  % if Lesk of a synset=0 than take most freq WNet sense
  set_param(glinks,no),     % adds to the PR graph links from glosses
  set_param(freq_links,no), % adds links from less freq to more freq synsets
  set_param(sem_links,no),  % adds links based on various sem. Rels between synsets in the text
  set_param(co_occ,no),     % adds links for words co-occuring in a small window in a sentence
  set_param(rank_order,no), % orders synsets by their Global WordNet Rank - not very useful
  set_param(random_seed,99),% sets random seed: use 'no' for sys. provided seed
  
  dis,
  endlog.

lesk:- %38p
  clear_params,
  set_param(logfile,'shuffled_lesk.txt'),   
  set_param(shuffle,yes),   % removes order bias coming from decreasing WNet Freq order
  set_param(freq_rank,no),  % combines PR rank with WNet Freq info
  set_param(rank,no),       % activates PageRank
  set_param(maxsyn,64),     % only takes first maxsyn synsets in decr. WNet Freq order
  set_param(links,no),      % adds to the PR graph links based on Rel-related synsets
  set_param(rel,xfail),     % specifies Rel - xlinked means any sense discriminating Rel
  set_param(lesk,yes),      % activates Lesk ordering - after shuffle
  set_param(freq_lesk,no),  % if Lesk of a synset=0 than take most freq WNet sense
  set_param(glinks,no),     % adds to the PR graph links from glosses
  set_param(freq_links,no), % adds links from less freq to more freq synsets
  set_param(sem_links,no),  % adds links based on various sem. Rels between synsets in the text
  set_param(co_occ,no),     % adds links for words co-occuring in a small window in a sentence
  set_param(rank_order,no), % orders synsets by their Global WordNet Rank - not very useful
  set_param(random_seed,99),% sets random seed: use 'no' for sys. provided seed
  
  dis,
  endlog.

pr_lesk:- %48p
  clear_params,
  set_param(logfile,'shuffled_pr_lesk.txt'),   
  set_param(shuffle,yes),   % removes order bias coming from decreasing WNet Freq order
  set_param(freq_rank,no),  % combines PR rank with WNet Freq info
  set_param(rank,yes),      % activates PageRank
  set_param(maxsyn,64),     % only takes first maxsyn synsets in decr. WNet Freq order
  set_param(links,yes),     % adds to the PR graph links based on Rel-related synsets
  set_param(rel,xlinked),   % specifies Rel - xlinked means any sense discriminating Rel
  set_param(lesk,yes),      % activates Lesk ordering - after shuffle
  set_param(freq_lesk,no),  % if Lesk of a synset=0 than take most freq WNet sense
  set_param(glinks,no),     % adds to the PR graph links from glosses
  set_param(freq_links,no), % adds links from less freq to more freq synsets
  set_param(sem_links,no),  % adds links based on various sem. Rels between synsets in the text
  set_param(co_occ,no),     % adds links for words co-occuring in a small window in a sentence
  set_param(rank_order,no), % orders synsets by their Global WordNet Rank - not very useful
  set_param(random_seed,99),% sets random seed: use 'no' for sys. provided seed
  
  dis,
  endlog.

% UNSHUFLLED ALGORITHMS
  
freq:- %62p
  clear_params,
  set_param(logfile,'first_most_freq.txt'),   
  set_param(shuffle,no),    % removes order bias coming from decreasing WNet Freq order
  set_param(freq_rank,no), % combines PR rank with WNet Freq info
  set_param(rank,no),      % activates PageRank
  set_param(maxsyn,1),     % only takes first maxsyn synsets in decr. WNet Freq order
  set_param(links,no),     % adds to the PR graph links based on Rel-related synsets
  set_param(rel,xfail),   % specifies Rel - xlinked means any sense discriminating Rel
  set_param(lesk,no),      % activates Lesk ordering - after shuffle
  set_param(freq_lesk,no), % if Lesk of a synset=0 than take most freq WNet sense
  set_param(glinks,no),     % adds to the PR graph links from glosses
  set_param(freq_links,no), % adds links from less freq to more freq synsets
  set_param(sem_links,no),  % adds links based on various sem. Rels between synsets in the text
  set_param(co_occ,no),     % adds links for words co-occuring in a small window in a sentence
  set_param(rank_order,no), % orders synsets by their Global WordNet Rank - not very useful
  set_param(random_seed,99),% sets random seed: use 'no' for sys. provided seed
  
  dis,
  endlog.
  
pr_freq:- % 68p
  clear_params,
  set_param(logfile,'pr_freq.txt'),   
  set_param(shuffle,no),    % removes order bias coming from decreasing WNet Freq order
  set_param(freq_rank,yes), % combines PR rank with WNet Freq info
  set_param(rank,yes),      % activates PageRank
  set_param(maxsyn,64),     % only takes first maxsyn synsets in decr. WNet Freq order
  set_param(links,yes),     % adds to the PR graph links based on Rel-related synsets
  set_param(rel,xlinked),   % specifies Rel - xlinked means any sense discriminating Rel
  set_param(lesk,no),      % activates Lesk ordering - after shuffle
  set_param(freq_lesk,no), % if Lesk of a synset=0 than take most freq WNet sense
  set_param(glinks,no),     % adds to the PR graph links from glosses
  set_param(freq_links,no), % adds links from less freq to more freq synsets
  set_param(sem_links,no),  % adds links based on various sem. Rels between synsets in the text
  set_param(co_occ,no),     % adds links for words co-occuring in a small window in a sentence
  set_param(rank_order,no), % orders synsets by their Global WordNet Rank - not very useful
  set_param(random_seed,99),% sets random seed: use 'no' for sys. provided seed
  
  dis,
  endlog.

lesk_freq:- % 66p
  clear_params,
  set_param(logfile,'lesk_freq.txt'),   
  set_param(shuffle,no),    % removes order bias coming from decreasing WNet Freq order
  set_param(freq_rank,no), % combines PR rank with WNet Freq info
  set_param(rank,no),      % activates PageRank
  set_param(maxsyn,64),     % only takes first maxsyn synsets in decr. WNet Freq order
  set_param(links,no),     % adds to the PR graph links based on Rel-related synsets
  set_param(rel,xfail),   % specifies Rel - xlinked means any sense discriminating Rel
  set_param(lesk,yes),      % activates Lesk ordering - after shuffle
  set_param(freq_lesk,yes), % if Lesk of a synset=0 than take most freq WNet sense
  set_param(glinks,no),     % adds to the PR graph links from glosses
  set_param(freq_links,no), % adds links from less freq to more freq synsets
  set_param(sem_links,no),  % adds links based on various sem. Rels between synsets in the text
  set_param(co_occ,no),     % adds links for words co-occuring in a small window in a sentence
  set_param(rank_order,no), % orders synsets by their Global WordNet Rank - not very useful
  set_param(random_seed,99),% sets random seed: use 'no' for sys. provided seed
  
  dis,
  endlog.

best:- % 68p
  clear_params,
  set_param(logfile,'best_pr_lesk_freq.txt'),   
  set_param(shuffle,no),    % removes order bias coming from decreasing WNet Freq order
  set_param(freq_rank,yes), % combines PR rank with WNet Freq info
  set_param(rank,yes),      % activates PageRank
  set_param(maxsyn,64),     % only takes first maxsyn synsets in decr. WNet Freq order
  set_param(links,yes),     % adds to the PR graph links based on Rel-related synsets
  set_param(rel,xlinked),   % specifies Rel - xlinked means any sense discriminating Rel
  set_param(lesk,yes),      % activates Lesk ordering - after shuffle
  set_param(freq_lesk,yes), % if Lesk of a synset=0 than take most freq WNet sense
  set_param(glinks,no),     % adds to the PR graph links from glosses
  set_param(freq_links,no), % adds links from less freq to more freq synsets
  set_param(sem_links,no),  % adds links based on various sem. Rels between synsets in the text
  set_param(co_occ,no),     % adds links for words co-occuring in a small window in a sentence
  set_param(rank_order,no), % orders synsets by their Global WordNet Rank - not very useful
  set_param(random_seed,99),% sets random seed: use 'no' for sys. provided seed
  
  dis,
  endlog.
