import 'package:flutter/material.dart';

class KantinPage extends StatelessWidget {
  const KantinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.getGradientBackground(),
        child: Column(
          children: [
            const Logo(),
            const KantinText(),
            const SearchBar(),
            const SizedBox(height: 20), // Spacing
            ScrollableButtonSection(),
          ],
        ),
      ),
    );
  }
}

class ScrollableButtonSection extends StatefulWidget {
  const ScrollableButtonSection({super.key});

  @override
  _ScrollableButtonSectionState createState() => _ScrollableButtonSectionState();
}

class _ScrollableButtonSectionState extends State<ScrollableButtonSection> {
  int _activeIndex = 0; // Indeks tombol yang aktif

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            CustomButton(
              text: 'Button 1',
              isActive: _activeIndex == 0,
              onPressed: () => _setActiveButton(0),
            ),
            SizedBox(width: 10),
            CustomButton(
              text: 'Button 2',
              isActive: _activeIndex == 1,
              onPressed: () => _setActiveButton(1),
            ),
            SizedBox(width: 10),
            CustomButton(
              text: 'Button 3',
              isActive: _activeIndex == 2,
              onPressed: () => _setActiveButton(2),
            ),
            SizedBox(width: 10),
            CustomButton(
              text: 'Button 4',
              isActive: _activeIndex == 3,
              onPressed: () => _setActiveButton(3),
            ),
          ],
        ),
      ),
    );
  }

  void _setActiveButton(int index) {
    setState(() {
      _activeIndex = index;
    });
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.isActive,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: isActive ? AppColors.accentColor : Colors.white,
        onPrimary: isActive ? Colors.white : AppColors.accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.accentColor),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        elevation: isActive ? 5 : 0,
      ),
      child: Text(text),
    );
  }
}