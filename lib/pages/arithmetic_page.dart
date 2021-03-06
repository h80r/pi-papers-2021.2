import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:pi_papers_2021_2/models/operation_selection.dart';

import 'package:pi_papers_2021_2/utils/hooks/image_hook.dart';
import 'package:pi_papers_2021_2/utils/hooks/picker_hook.dart';
import 'package:pi_papers_2021_2/utils/web_utils.dart';

import 'package:pi_papers_2021_2/widgets/widgets.dart';

import 'package:pi_papers_2021_2/algorithm/arithmetic_functions.dart';

class ArithmeticPage extends HookWidget {
  const ArithmeticPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageA = useImage();
    final imageB = useImage();
    final imageC = useImage();
    final operation = useState<ArithmeticOperation?>(null);

    return Scaffold(
      appBar: const Header(
        title: 'Operações Aritméticas',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 5.0,
          runSpacing: 16.0,
          alignment: WrapAlignment.center,
          children: [
            ImageSelector(
              isResult: false,
              image: imageA.widget,
              onTap: () => usePicker(imageA),
            ),
            const SizedBox(width: 10),
            ImageSelector(
              isResult: false,
              image: imageB.widget,
              onTap: () => usePicker(imageB),
            ),
            const SizedBox(width: 10),
            ImageSelector(
              isResult: true,
              image: imageC.widget,
              message: imageC.message,
            ),
            Selector(
              options: [
                OperationSelection(
                  value: 'Adição',
                  icon: ImageIcon(
                    AssetImage(
                      path('images/prototype/icons/plus.png'),
                    ),
                  ),
                  onPressed: () => operation.value = sum,
                ),
                OperationSelection(
                  value: 'Subtração',
                  icon: ImageIcon(
                    AssetImage(
                      path('images/prototype/icons/minus.png'),
                    ),
                  ),
                  onPressed: () => operation.value = subtraction,
                ),
                OperationSelection(
                  value: 'Multiplicação',
                  icon: ImageIcon(
                    AssetImage(
                      path('images/prototype/icons/times.png'),
                    ),
                  ),
                  onPressed: () => operation.value = multiplication,
                ),
                OperationSelection(
                  value: 'Divisão',
                  icon: ImageIcon(
                    AssetImage(
                      path('images/prototype/icons/slash.png'),
                    ),
                  ),
                  onPressed: () => operation.value = division,
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(16.0)),
            Center(
              child: FinishButton(
                text: 'Operar',
                onPressed: () => imageC.data = operate(
                  imageA.data,
                  imageB.data,
                  operation.value,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
