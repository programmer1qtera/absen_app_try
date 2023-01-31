import 'package:absen_try_app/page/home/controller/tes_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class TestModel extends GetView<TestController> {
  TestModel({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TestController());
    return Scaffold(
      body: GetBuilder<TestController>(builder: (c) {
        return Center(
          child: c.isLoading == true
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${c.result.name}'),
                    SizedBox(
                      height: 10,
                    ),
                    Text('${c.resultKehadiran[1].address}'),
                    SizedBox(height: 10),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: c.resultKehadiran.length,
                      itemBuilder: (context, index) {
                        var itemDataKehadiran = c.resultKehadiran[index];
                        return c.isLoading == true
                            ? CircularProgressIndicator()
                            : Center(child: Text('${itemDataKehadiran.place}'));
                      },
                    )
                  ],
                ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.tryFakeGps();
        },
      ),
    );
  }
}
