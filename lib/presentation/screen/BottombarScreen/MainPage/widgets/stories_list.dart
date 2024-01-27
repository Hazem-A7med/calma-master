import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nadek/logic/cubit/stories_cubit.dart';
import 'package:nadek/logic/states/stories_states.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

import '../../../../../data/model/stories_model.dart';

class StoriesList extends StatefulWidget {
  const StoriesList({Key? key}) : super(key: key);

  @override
  State<StoriesList> createState() => _StoriesListState();
}

class _StoriesListState extends State<StoriesList> {
  @override
  void initState() {
    BlocProvider.of<StoriesCubit>(context,listen: false).fetchMyStories();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoriesCubit,StoriesState>(
      builder: (context, state) {
      if (state is StoriesLoadingState) {
        return Center(child: CircularProgressIndicator());
      }
      else if (state is StoriesLoadedState) {
        List<Story> stories = state.stories;
        return SizedBox(
            height: 115,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>
                (index==0)?  SizedBox(width: 82,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: List.filled(1, BoxShadow(
                                        color: Colors.white38.withOpacity(.3),
                                        blurRadius: 3,
                                        spreadRadius: 1)),
                                    shape: BoxShape.circle, border: Border.all(style: BorderStyle.values[2],
                                  color: Color(0xffE11717), width: 5,),
                                    color: Colors.white),
                                height: 80,
                                width: 80),
                          ),
                          const Text(
                            'Ahmad Moe', overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color(0xffE11717), fontSize: 12),)
                        ],
                      ),
                    ):
                ////////////////////////////////////////////////////////////////////////////////
                SizedBox(width: 82,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                            decoration: BoxDecoration(
                                boxShadow: List.filled(1, BoxShadow(
                                    color: Colors.white38.withOpacity(.3),
                                    blurRadius: 3,
                                    spreadRadius: 1)),
                                shape: BoxShape.circle, border: Border.all(
                              color: Color(0xffE11717), width: 5,),
                                color: Colors.white),
                            height: 80,
                            width: 80),
                      ),
                      const Text(
                        'Ahmad Moe', overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Color(0xffE11717), fontSize: 12),)
                    ],
                  ),
                ),
                separatorBuilder: (context, index) =>
                const SizedBox(width: 20,),
                itemCount: 20));
      } else if (state is StoriesErrorState) {
        return Center(
          child: Text('Error: ${state.error}'),
        );
      } else {
        return Container(); // Placeholder, you might want to handle other states
      }},
      listener: (BuildContext context, Object? state) {  },
    );
  }
}
