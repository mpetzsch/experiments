/ other peers
.sync.peers:(`$())!(`int$());

lg:{show string[.z.z]," # ",x}

/ my address
.sync.address:hsym `$string[.z.h],":",string[system"p"];

/ register a new peer
.sync.register:{[address] 
	if[(.sync.address~address);:`]; / don't register self
	if[(not null first .sync.peers[address]);:`]; / already registered so don't pass on as already have
	lg["new sync peer: ",string[address]];
	.sync.peers[address]:@[{hopen(x;100)};address;{lg "failed to connect to new peer @ ",string[x],": ",y; 0N}[address;]];
	/ tell all peers about this new peer 
	{[peerHandle]
		{[nh;addr]
			.[{(neg x)(`.sync.register;y)};(nh;addr);:];
		}[peerHandle;] peach (key .sync.peers),.sync.address;
	} peach .sync.peerHandles[];
 };

/ peer removing itself
.sync.unregister:{[address]
	lg["peer removed: ",string[address]];
	@[hclose;.sync.peers[address];{x}];
	.sync.peers:address _ .sync.peers;
 };

.sync.peerHandles:{ value[.sync.peers] except 0N }

/ called by peers to add new addresses - just add don't attempt connection until reconnect
.sync.peerPush:{[newPeers]
	newPeers:(newPeers except (.sync.address,key .sync.peers));
	if[0<count newPeers;[lg["received new peers ",-3!newPeers]; .sync.peers[newPeers except (.sync.address,key .sync.peers)]:0N]];
 };

/ reconnect sync peers
.sync.reconnectAndPushPeers:{
	{[a]
		connectionOk:@[neg .sync.peers[a];"1b";0b];
		if[not connectionOk~0b;[(neg .sync.peers[a])(`.sync.peerPush;key .sync.peers);:`]];
		.sync.peers[a]:@[{hopen(x;100)};a;0N];
		$[null .sync.peers[a];lg["cannot reconnect ",string[a]];lg["peer ",string[a]," connected"]];
	} peach key .sync.peers;
 };

/ read initial peer set and register these peers
.sync.register each raze value flip (enlist "S";enlist",")0:`:peers.csv

.z.ts:{
	.sync.reconnectAndPushPeers[];
 };

.z.exit:{
	{ .[{ x(y;z); hclose[x];}[x;];(`.sync.unregister;.sync.address);{x}]; } peach .sync.peerHandles[];
 };

\t 10000
\c 250 250

