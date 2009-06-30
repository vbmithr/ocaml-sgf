type collection = gametree list

and gametree = sequence * (gametree list)

and sequence = node list

and node = property list

and property = { prop_name:  string;
                 prop_value: string list }
