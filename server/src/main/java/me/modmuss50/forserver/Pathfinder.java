package me.modmuss50.forserver;

import es.usc.citius.hipster.algorithm.Algorithm;
import es.usc.citius.hipster.algorithm.Hipster;
import es.usc.citius.hipster.graph.GraphBuilder;
import es.usc.citius.hipster.graph.GraphSearchProblem;
import es.usc.citius.hipster.graph.HipsterDirectedGraph;
import es.usc.citius.hipster.model.problem.SearchProblem;

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
		Algorithm.SearchResult searchResult = pathFind(current, dest);
		System.out.println(searchResult);
		return null;
	}

}
