type property   = { prop_name:  string;
                    prop_value: string list }
type node       = property list
type sequence   = node list
type gametree   = Node of sequence * gametree list | Leaf of sequence
type collection = gametree list
