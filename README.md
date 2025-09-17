# VisionVox

**AI-powered Assistive App for the Visually Impaired**  
Empowering Independence, Safety & Accessibility  

---

## 🚩 Problem Statement
- **39M** blind and **246M** visually impaired people globally.  
- Key struggles: navigating obstacles, reading printed text, handling money.  
- Current aids: white cane, screen readers, costly smart glasses.  
- **Challenges**: Reduced independence, high reliance on others, affordability barriers.  

---

## 👥 Target Audience
- **Primary User**: Arun, 22, visually impaired student needing help with:
  - Navigation  
  - Reading printed text  
  - Currency recognition  
- **Secondary Stakeholders**: NGOs, schools for the blind, accessibility organizations.  

---

## 🔍 Current Alternatives & Gaps
- **What people use now**: White cane, family/friends, screen readers, remote-help apps, smart glasses, single-purpose apps.  
- **Why they fail**:  
  - Single-function tools  
  - High cost & poor accessibility  
  - Dependence on others  
  - Latency & connectivity issues  
  - Limited localization  
  - Fragmented experience  

✅ **VisionVox closes these gaps with:**  
- Integrated app (object + text + currency recognition)  
- Affordable mobile-only solution  
- Offline capability  
- Simple controls  
- Robust ML models  

---

## 🌟 Unique Selling Proposition
> “A single mobile app that integrates object detection, text-to-speech, and currency recognition for visually impaired users.”

---

## 📱 Solution Overview
**VisionVox Mobile App Features:**  
- 🖼️ Object & Scene Recognition (YOLOv4)  
- 🔊 Text-to-Speech (OCR + TTS)  
- 💵 Currency Identification  
- 🎙️ Simple voice and button-based controls  

---

## 📊 Market Potential
- **India**: ~12M visually impaired  
- **Global**: ~285M visually impaired  
- **Assistive tech market**: $31B by 2030  
- **Adoption Path**: NGOs → Students → Global market  

---

## 💼 Business & Operating Model
- **B2C**: Free app with optional premium features  
- **B2B/NGO Partnerships**  
- **Revenue Streams**: Premium features, partnerships, CSR funding  

---

## 🛠️ Implementation Strategy (Hackathon Feasible)
- **Day 1**: Integrate YOLOv4 object detection  
- **Day 2**: Add OCR + TTS  
- **Day 3**: Add currency recognition + polish UI  

**Tech Stack:**  
- Flutter  
- TensorFlow Lite  
- OpenCV  
- Google TTS API  

---

## 📏 Validation & Metrics
- **Validation**: Pilot test with visually impaired students  
- **Metrics**:  
  - Detection Accuracy ≥ **85%**  
  - TTS Latency < **2s**  
  - Positive feedback from **20+ test users**  

---

## 🥇 Competition & Differentiation
- **Screen Readers**: Text only → VisionVox adds real-world perception  
- **Smart Glasses**: Expensive, hardware-dependent → VisionVox is mobile-only  
- **Other Apps**: Usually single-purpose → VisionVox integrates multiple features  

---

## 👨‍💻 Team
- **Prasad Shetty** – ML Model Development  
- **Reevan Lobo** – Mobile App Development  
- **Pratham H** – System Integration  

---

## 🙌 Ask
- Mentorship & funding support  
- Partnerships with NGOs & accessibility groups  

---

## ⚙️ Setup & Installation

### 1️⃣ Install Flutter
Follow the official guide for your OS: [Flutter Installation Docs](https://docs.flutter.dev/get-started/install)

Or use the following commands:

```bash
# Clone Flutter SDK (for Linux/macOS)
git clone https://github.com/flutter/flutter.git -b stable

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Check installation
flutter doctor

---

## 🚀 Flutter Useful Commands

```bash
# Check Flutter version and environment setup
flutter doctor

# Get all dependencies listed in pubspec.yaml
flutter pub get

# Run the app on a connected device or emulator
flutter run

# Run with specific device
flutter run -d <device_id>

# Show all connected devices
flutter devices

# Hot reload (after making code changes while running the app)
r

# Hot restart (full app restart in debug mode)
R

# Run unit/widget tests
flutter test

# Analyze project for errors & suggestions
flutter analyze

# Build a release APK (Android)
flutter build apk --release

# Build an App Bundle for Play Store
flutter build appbundle --release

# Build for iOS (requires macOS & Xcode)
flutter build ios --release

# Clean project (useful if build issues occur)
flutter clean

