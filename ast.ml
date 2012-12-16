type property   = { pname:  string;
                    pvalue: string list }
type node       = property list
type sequence   = node list
type gametree   = Node of sequence * gametree list | Leaf of sequence
type collection = gametree list
