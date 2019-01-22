package me.modmuss50.forserver;

import es.usc.citius.hipster.algorithm.Algorithm;
import es.usc.citius.hipster.algorithm.Hipster;
import es.usc.citius.hipster.graph.GraphBuilder;
import es.usc.citius.hipster.graph.GraphSearchProblem;
import es.usc.citius.hipster.graph.HipsterDirectedGraph;
import es.usc.citius.hipster.model.impl.WeightedNode;
import es.usc.citius.hipster.model.problem.SearchProblem;

import java.util.List;

public class Pathfinder {

	HipsterDirectedGraph<Types.ComputerData, Integer> graph;

	public void build(DataManager dataManager){
		GraphBuilder<Types.ComputerData, Integer> graphBuilder = GraphBuilder.create();
		dataManager.switches.values().forEach(aSwitch -> {
			Utils.ifValid(aSwitch.turnsTo, s -> graphBuilder.connect(aSwitch).to(dataManager.getByName(s)).withEdge(10));
			Utils.ifValid(aSwitch.contiunesTo, s -> graphBuilder.connect(aSwitch).to(dataManager.getByName(s)).withEdge(10));
		});

		graph = graphBuilder.createDirectedGraph();
	}

	public Algorithm.SearchResult pathFind(Types.ComputerData start, Types.ComputerData end){
		SearchProblem p = GraphSearchProblem
			.startingFrom(start)
			.in(graph)
			.takeCostsFromEdges()
			.build();

		Algorithm.SearchResult result = Hipster.createDijkstra(p).search(end);
		return result;
	}

	public Types.ComputerData getNext(Types.ComputerData current, Types.ComputerData dest){
		if(current == null || dest == null){
			throw new RuntimeException("invalid point");
		}
		System.out.println("Requesting path find from " + current.name + " to " + dest.name);
		Algorithm.SearchResult searchResult = pathFind(current, dest);
		List<WeightedNode> path = searchResult.getGoalNode().path();
		System.out.println("path:" + path);
		Types.ComputerData next = (Types.ComputerData) path.get(1).state();
		return next;
	}

}
