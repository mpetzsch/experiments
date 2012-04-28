/ a library which provides synchronization of data over a mesh-like set of nodes
/ each node is initially configured to know about at least one other node, it then discovers any nodes connected to this other node and any in turn connected to them etc
/ in this way - shortly after starting every node should be aware of every other - meaning that any single node failing should not be a problem as there is no single node link between nodes
/ at startup of any node - the node will ask other nodes for their state and compare it with its own
/ - if the state is different then the started node
/ when the state of a node is modified - it pushes this message to all of the other nodes it is aware of so that they remain synchronized

/ address!handle
.sn.nodes:()!();

/ log of previous messages received
.sn.msglog:();

/ copy of initial data states
.sn.initial:()!();

/ startup connect and sync
.sn.start:{
 };

/ notify others of removal
.sn.exit:{
 };

/ push a message out mesh
.sn.push:{
 };

/ receive incoming messages
.sn.upd:{
 };

/ give out a snapshot of all syncd data
.sn.snap:{
 };

/ retrieve this node's priority (higher is higher)
.sn.priority:{
 };
