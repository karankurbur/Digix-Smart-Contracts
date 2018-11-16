const express = require('express')
const app = express()
const port = 3000
var bodyParser = require('body-parser')
app.use(bodyParser.json());

var transactions = [];
var graph = new Graph();

app.post('/sendTransaction', (req, res) => {
  //console.log(req.body.sender);
  var sent = {
    sender: req.body.sender,
    receiver: req.body.receiver,
    amount: req.body.amount,
    hash: req.body.hash
  }
  transactions.push(sent);
  //graph.addEdge(req.body.sender, req.body.receiver);
  res.send(true);
})

app.get('/getTransactionsFrom', (req, res) => {
  var fromAddress = req.query.from;
  var output = [];
  for (var i = 0; i < transactions.length; i++) {
    if (transactions[i].sender == fromAddress) {
      output.push(transactions[i]);
    }
  }
  res.send(output);
}
)

app.get('/getTransactionsTo', (req, res) => {
  var toAddress = req.query.to;
  var output = [];
  for (var i = 0; i < transactions.length; i++) {
    if (transactions[i].receiver == toAddress) {
      output.push(transactions[i]);
    }
  }
  res.send(output);
}
)

app.get('/getTransactionsBetweenTwoAddresses', (req, res) => {
  var fromAddress = req.query.from;
  var toAddress = req.query.to;

  var output = [];
  for (var i = 0; i < transactions.length; i++) {
    if (transactions[i].receiver == toAddress && transactions[i].receiver == fromAddress) {
      output.push(transactions[i]);
    }
  }
  res.send(output);
}
)

app.get('/getShortestPath', (req, res) => {
  var start = req.query.from;
  var end = req.query.to;


  //check that both points are in the graph

  graph.addEdge('A', 'B');
  graph.addEdge('B', 'C');
  graph.addEdge('B', 'E');
  graph.addEdge('C', 'D');
  graph.addEdge('C', 'E');
  graph.addEdge('C', 'G');
  graph.addEdge('D', 'E');
  graph.addEdge('E', 'F');


  var output = shortestPath(graph, start, end);
  res.send(output)
}
)



//https://stackoverflow.com/questions/32527026/shortest-path-in-javascript

function Graph() {
  var neighbors = this.neighbors = {}; // Key = vertex, value = array of neighbors.

  this.addEdge = function (u, v) {
    if (neighbors[u] === undefined) {  // Add the edge u -> v.
      neighbors[u] = [];
    }
    neighbors[u].push(v);
    if (neighbors[v] === undefined) {  // Also add the edge v -> u in order
      neighbors[v] = [];               // to implement an undirected graph.
    }                                  // For a directed graph, delete
    neighbors[v].push(u);              // these four lines.
  };

  return this;
}

function shortestPath(graph, source, target) {
  if (source == target) {   // Delete these four lines if
    print(source);          // you want to look for a cycle
    return;                 // when the source is equal to
  }                         // the target.
  var queue = [source],
    visited = { source: true },
    predecessor = {},
    tail = 0;
  while (tail < queue.length) {
    var u = queue[tail++],  // Pop a vertex off the queue.
      neighbors = graph.neighbors[u];
    for (var i = 0; i < neighbors.length; ++i) {
      var v = neighbors[i];
      if (visited[v]) {
        continue;
      }
      visited[v] = true;
      if (v === target) {   // Check if the path is complete.
        var path = [v];   // If so, backtrack through the path.
        while (u !== source) {
          path.push(u);
          u = predecessor[u];
        }
        path.push(u);
        path.reverse();
        //print(path.join(' &rarr; '));
        //print(path.join(' '));
        return path.join();
      }
      predecessor[v] = u;
      queue.push(v);
    }
  }
  return null;
  //print('there is no path from ' + source + ' to ' + target);
}

function print(s) {  // A quick and dirty way to display output.
  s = s || '';
  console.log(s);
}

function addToTransactions(send, rec, amt, hashValue) {
  
}

function fillAddress(address) {
  var zeros = 42 - address.length;
  var out = address.substring(0,2);
  
  for(var i = 0; i < zeros ; i++) {

  }

}


app.listen(port, () => {

  var senders = ["0xa","0xb","0xb","0xc","0xc","0xc","0xd","0xd"];
  var receivers = ["0xb","0xc","0xe","0xd","0xe","0xg","0xe","0xf"];
  
  for(var i = 0; i < senders.length;i++) {    
    var amount = Math.floor(Math.random() * 10000);
    var hash = "0x" + i ;
    addToTransactions(sender[i],receivers[i],amount,hash);
  }

  var sample = {
    sender: "0xa",
    receiver: "0xb",
    amount: 1000,
    hash: "abcde123144123"
  }
  transactions.push(sample);

  sample = {
    sender: "0x11",
    receiver: "0x51",
    amount: 55,
    hash: "abcde3234422123144123"
  }

  transactions.push(sent);

  console.log(`Example app listening on port ${port}!`)
})