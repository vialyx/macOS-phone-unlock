# PhoneUnlocker - System Architecture & Diagrams

## 🏗️ System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        USER'S WORKSPACE                         │
│  ┌──────────────────┐              ┌──────────────────────┐    │
│  │   MAC MACHINE    │              │   IPHONE DEVICE      │    │
│  │                  │              │                      │    │
│  │  ┌────────────┐  │              │  ┌──────────────┐   │    │
│  │  │PhoneUnlocker──────────────────→ Face ID Sensor │   │    │
│  │  │   (App)    │  │   WiFi/BLE   │  └──────────────┘   │    │
│  │  └────────────┘  │              │       ▲              │    │
│  │        │         │              │       │              │    │
│  │        │         │              │  ┌────────────┐     │    │
│  │        ▼         │              │  │Apple Pay   │     │    │
│  │  ┌────────────┐  │              │  │PassKit     │     │    │
│  │  │PassKit UI  │  │              │  └────────────┘     │    │
│  │  │(Menu Bar)  │  │              │                      │    │
│  │  └────────────┘  │              └──────────────────────┘    │
│  │        │         │                                           │
│  │        ▼         │                                           │
│  │  ┌────────────┐  │                                           │
│  │  │Screensaver │  │                                           │
│  │  │Manager     │  │                                           │
│  │  │(IOKit)     │  │                                           │
│  │  └────────────┘  │                                           │
│  └──────────────────┘                                           │
│                                                                  │
│  All components communicate via PassKit framework               │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Authentication Flow

```
1. USER ACTION
   ┌────────────────────────────────────────────────┐
   │ Screensaver Active (5 min idle)                │
   │ User clicks "Verify with iPhone" button        │
   └────────────────────┬───────────────────────────┘
                        │
                        ▼
2. PASSKIT INITIALIZATION
   ┌────────────────────────────────────────────────┐
   │ ApplePayController creates payment request     │
   │ Amount: $0.00 (zero-dollar transaction)        │
   │ Creates PKPaymentAuthorizationViewController   │
   └────────────────────┬───────────────────────────┘
                        │
                        ▼
3. PAYMENT SHEET DISPLAY
   ┌────────────────────────────────────────────────┐
   │ PassKit framework displays payment UI on Mac   │
   │ Shows "iPhone Authentication - $0.00"          │
   │ User sees "Complete with iPhone" prompt        │
   └────────────────────┬───────────────────────────┘
                        │
        ┌───────────────┴────────────────┐
        │      WiFi/Bluetooth            │
        │      Communication             │
        ▼                                ▼
4. IPHONE INTERACTION
   ┌────────────────────────────────────────────────┐
   │ iPhone receives payment request                │
   │ Shows Face ID authentication prompt            │
   │ User sees face detection screen                │
   └────────────────────┬───────────────────────────┘
                        │
                        ▼
5. BIOMETRIC VERIFICATION
   ┌────────────────────────────────────────────────┐
   │ iPhone processes Face ID                       │
   │ Compares user's face to stored data            │
   │ Returns success/failure                        │
   └────────────────────┬───────────────────────────┘
                        │
        ┌───────────────┴────────────────┐
        │      WiFi/Bluetooth            │
        │      Communication             │
        ▼                                ▼
6. MAC RECEIVES RESPONSE
   ┌────────────────────────────────────────────────┐
   │ ApplePayController receives Face ID result     │
   │ Verifies payment authorization success         │
   │ Calls ScreensaverManager.unlockScreensaver()   │
   └────────────────────┬───────────────────────────┘
                        │
                        ▼
7. SCREENSAVER UNLOCK
   ┌────────────────────────────────────────────────┐
   │ ScreensaverManager simulates mouse movement    │
   │ Simulates spacebar keypress                    │
   │ Screensaver releases and desktop appears       │
   │ User can now interact with Mac                 │
   └────────────────────┬───────────────────────────┘
                        │
                        ▼
8. SUCCESS
   ┌────────────────────────────────────────────────┐
   │ UI shows "Mac unlocked successfully!"          │
   │ Success message displays for 2 seconds         │
   │ Mac is ready to use                            │
   └────────────────────────────────────────────────┘
```

---

## 🏠 Component Relationships

```
┌──────────────────────────────────────────────────────┐
│              PhoneUnlockerApp (Entry Point)          │
│         (Initializes and manages everything)         │
└──────────────────┬───────────────────────────────────┘
                   │
        ┌──────────┴───────────┬──────────────┐
        │                      │              │
        ▼                      ▼              ▼
   ┌─────────────┐     ┌──────────────┐  ┌──────────┐
   │ ContentView │     │ ApplePay     │  │Screensaver
   │  (UI Layer) │     │Controller    │  │Manager
   │             │     │(PassKit)     │  │(System)
   │ • Menu bar  │     │              │  │
   │ • Buttons   │     │ • Payment    │  │ • Idle
   │ • Status    │     │ • Face ID    │  │ • Monitor
   │ • Messages  │     │ • Auth       │  │ • Unlock
   └──────┬──────┘     └──────┬───────┘  └─────┬────┘
          │                   │               │
          └───────────────────┼───────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │ PassKit Framework│
                    │ (Apple's API)    │
                    └──────┬───────────┘
                           │
                    WiFi/Bluetooth
                           │
                    ┌──────┴───────────┐
                    │ User's iPhone    │
                    │ (Face ID Device) │
                    └──────────────────┘
```

---

## 📊 State Machine Diagram

```
                START
                  │
                  ▼
         ┌─────────────────┐
         │  App Launched   │
         └────────┬────────┘
                  │
                  ▼
      ┌──────────────────────┐
      │ Check Dependencies   │
      │ • Apple Pay active?  │
      │ • Permissions ok?    │
      └────────┬─────────────┘
               │
         ┌─────┴─────┐
         │           │
        ✓            ✗
        │            │
        ▼            ▼
    READY      SHOW ERROR
      │           │
      │           └─────┐
      │                 │
      └─────────────────┘
               │
               ▼
    ┌──────────────────────┐
    │  Monitoring Loop     │
    │  (Every 2 seconds)   │
    │ • Check idle time    │
    │ • Update status      │
    └────────┬─────────────┘
             │
             ▼
       ┌─────────────┐
       │ Screensaver │
       │   Active?   │
       └──┬────────┬─┘
         YES      NO
          │        │
          ▼        ▼
      ACTIVE    INACTIVE
          │        │
          │        │
      ┌───┴────────┴────┐
      │   User clicks   │
      │  "Verify with"  │
      │   iPhone"       │
      └────────┬────────┘
               │
               ▼
    ┌──────────────────────┐
    │ Start Authentication │
    │ • Show payment sheet │
    │ • Send to iPhone     │
    └────────┬─────────────┘
             │
             ▼
    ┌──────────────────────┐
    │ Wait for Face ID     │
    │ (user action on      │
    │  iPhone)             │
    └────────┬─────────────┘
             │
         ┌───┴────┐
         │        │
        ✓         ✗
        │         │
        ▼         ▼
     SUCCESS    FAILURE
        │         │
        │         ▼
        │    ┌──────────┐
        │    │Show Error│
        │    └────┬─────┘
        │         │
        ▼         ▼
    ┌──────────────────────┐
    │ Unlock Screensaver   │
    │ (if success)         │
    └────────┬─────────────┘
             │
             ▼
    ┌──────────────────────┐
    │ Desktop Accessible   │
    │ Show success message │
    └────────┬─────────────┘
             │
             ▼
    ┌──────────────────────┐
    │  Back to Monitoring  │
    │    Loop (or idle)    │
    └──────────────────────┘
```

---

## 🔐 Security Model

```
┌──────────────────────────────────────────────────────┐
│         MULTI-LAYER SECURITY ARCHITECTURE           │
│                                                      │
│  Layer 1: BIOMETRIC AUTHENTICATION                  │
│  ┌────────────────────────────────────────────┐    │
│  │ Face ID on iPhone (required)               │    │
│  │ • Cannot be bypassed                       │    │
│  │ • Unique to user                           │    │
│  │ • Hardware-backed security                 │    │
│  └────────────────────────────────────────────┘    │
│                      ▼                               │
│  Layer 2: FRAMEWORK SECURITY                       │
│  ┌────────────────────────────────────────────┐    │
│  │ PassKit Framework (Apple's system)         │    │
│  │ • Enterprise-grade encryption              │    │
│  │ • Secure communication protocol            │    │
│  │ • No credentials transferred               │    │
│  └────────────────────────────────────────────┘    │
│                      ▼                               │
│  Layer 3: LOCAL SECURITY                           │
│  ┌────────────────────────────────────────────┐    │
│  │ Mac-side protections                       │    │
│  │ • Accessibility permissions required       │    │
│  │ • No password storage                      │    │
│  │ • No data on disk                          │    │
│  │ • Hardened runtime enabled                 │    │
│  └────────────────────────────────────────────┘    │
│                      ▼                               │
│  Layer 4: SYSTEM INTEGRATION                       │
│  ┌────────────────────────────────────────────┐    │
│  │ OS-level security mechanisms               │    │
│  │ • Screensaver lock enforcement             │    │
│  │ • IOKit sandbox                            │    │
│  │ • System Integrity Protection (SIP)        │    │
│  └────────────────────────────────────────────┘    │
│                                                      │
│  Result: FAIL-SAFE AUTHENTICATION                   │
│  • No single point of failure                       │
│  • Multiple security checks                         │
│  • Hardware-backed verification                     │
└──────────────────────────────────────────────────────┘
```

---

## 🎯 Data Flow Diagram

```
USER INITIATES
      │
      ▼
┌─────────────────────────────────────────────┐
│      ContentView.initiatePhoneAuth()        │
└──────────────────┬──────────────────────────┘
                   │
                   ▼
    ┌──────────────────────────────┐
    │ Validate Screensaver Status  │
    │ (from ScreensaverManager)    │
    └──────────────┬───────────────┘
                   │
                   ▼
    ┌──────────────────────────────┐
    │ Call ApplePayController      │
    │ initiateZeroTransaction()    │
    └──────────────┬───────────────┘
                   │
                   ▼
    ┌──────────────────────────────┐
    │ Create PKPaymentRequest      │
    │ • Amount: $0.00              │
    │ • Network: Visa, MC, Amex    │
    │ • Merchant ID set            │
    └──────────────┬───────────────┘
                   │
                   ▼
    ┌──────────────────────────────┐
    │ Present Payment Controller   │
    │ (PassKit UI shown on Mac)    │
    └──────────────┬───────────────┘
                   │
        ┌──────────┴──────────┐
        │  Network Transport  │
        │  (WiFi/Bluetooth)   │
        ▼                      ▼
    ┌──────────────────────────────┐
    │ iPhone receives request      │
    │ Shows Face ID UI             │
    └──────────────┬───────────────┘
                   │
                   ▼
    ┌──────────────────────────────┐
    │ User performs Face ID scan   │
    │ (Hardware sensor reads face) │
    └──────────────┬───────────────┘
                   │
                   ▼
    ┌──────────────────────────────┐
    │ iPhone verifies and responds │
    │ (PKPayment with status)      │
    └──────────────┬───────────────┘
                   │
        ┌──────────┴──────────┐
        │  Network Transport  │
        │  (WiFi/Bluetooth)   │
        ▼                      ▼
    ┌──────────────────────────────┐
    │ Mac receives response        │
    │ (PKPaymentAuthorizationView) │
    └──────────────┬───────────────┘
                   │
             ┌─────┴─────┐
             │           │
           ✓             ✗
           │             │
           ▼             ▼
       SUCCESS       FAILURE
           │             │
           │             ▼
           │       ┌────────────┐
           │       │Show Error  │
           │       │Message     │
           │       └────────────┘
           │
           ▼
    ┌──────────────────────────────┐
    │ Call ScreensaverManager      │
    │ unlockScreensaver()          │
    └──────────────┬───────────────┘
                   │
                   ▼
    ┌──────────────────────────────┐
    │ Get current mouse position   │
    └──────────────┬───────────────┘
                   │
                   ▼
    ┌──────────────────────────────┐
    │ Create CGEvent mouse movement│
    │ Post event to HID event tap  │
    └──────────────┬───────────────┘
                   │
                   ▼
    ┌──────────────────────────────┐
    │ Create spacebar key events   │
    │ Post events to HID event tap │
    └──────────────┬───────────────┘
                   │
                   ▼
    ┌──────────────────────────────┐
    │ Restore mouse to original    │
    │ position                     │
    └──────────────┬───────────────┘
                   │
                   ▼
    ┌──────────────────────────────┐
    │ Screensaver releases         │
    │ Desktop becomes visible      │
    └──────────────┬───────────────┘
                   │
                   ▼
    ┌──────────────────────────────┐
    │ Show success message in UI   │
    │ "Mac unlocked successfully!" │
    └──────────────┬───────────────┘
                   │
                   ▼
                SUCCESS
```

---

## 🔌 Integration Points with macOS

```
┌────────────────────────────────────────────────┐
│          PhoneUnlocker Integration             │
│          with macOS System                     │
│                                                │
│  ┌──────────────────────────────────────┐    │
│  │ PassKit Framework                    │    │
│  │ └─ Apple Pay communication          │    │
│  │ └─ Payment sheet UI                 │    │
│  │ └─ Secure enclave access (iPhone)   │    │
│  └──────────────────────────────────────┘    │
│                      │                         │
│  ┌──────────────────────────────────────┐    │
│  │ IOKit Framework                      │    │
│  │ └─ System idle time query            │    │
│  │ └─ HID device monitoring             │    │
│  └──────────────────────────────────────┘    │
│                      │                         │
│  ┌──────────────────────────────────────┐    │
│  │ CGEvent Framework                    │    │
│  │ └─ Mouse movement events             │    │
│  │ └─ Keyboard events                   │    │
│  │ └─ HID event tap access              │    │
│  └──────────────────────────────────────┘    │
│                      │                         │
│  ┌──────────────────────────────────────┐    │
│  │ SwiftUI Framework                    │    │
│  │ └─ Menu bar application              │    │
│  │ └─ User interface rendering          │    │
│  └──────────────────────────────────────┘    │
│                      │                         │
│  ┌──────────────────────────────────────┐    │
│  │ System Preferences Integration       │    │
│  │ └─ Accessibility permissions         │    │
│  │ └─ Wallet & Apple Pay settings       │    │
│  └──────────────────────────────────────┘    │
│                                                │
└────────────────────────────────────────────────┘
```

---

## 📱 iPhone-Mac Communication

```
IPHONE                           MACOS
┌─────────────────────┐         ┌──────────────────────┐
│                     │         │                      │
│ Face ID Sensor      │         │ Menu Bar App         │
│                     │         │                      │
│        │            │         │         │            │
│        ▼            │         │         ▼            │
│ ┌──────────────┐   │         │ ┌─────────────────┐  │
│ │ Biometric    │   │         │ │ PassKit Request │  │
│ │ Verification │   │         │ │ (0.00 payment)  │  │
│ └──────┬───────┘   │         │ └────────┬────────┘  │
│        │           │         │          │           │
│        ▼           │         │          ▼           │
│ ┌──────────────┐   │         │ ┌─────────────────┐  │
│ │ Encode Face  │   │         │ │ Create         │  │
│ │ Match Result │   │         │ │ PKPayment      │  │
│ └──────┬───────┘   │         │ └────────┬────────┘  │
│        │           │         │          │           │
│ ┌──────┴────────────────────────────────┴──────┐   │
│ │                                               │   │
│ │         WiFi/Bluetooth Tunnel                │   │
│ │    (Secure PassKit Communication)            │   │
│ │                                               │   │
│ └──────┬────────────────────────────────┬──────┘   │
│        │                                │          │
│        ▼                                ▼          │
│ ┌──────────────┐   │         │ ┌─────────────────┐ │
│ │ Send Result  │   │         │ │ Receive Result  │ │
│ │ (Success)    │   │         │ │ (Face ID OK)    │ │
│ └──────────────┘   │         │ └──────┬──────────┘ │
│                     │         │        │            │
│                     │         │        ▼            │
│                     │         │ ┌──────────────┐    │
│                     │         │ │ Unlock       │    │
│                     │         │ │ Screensaver  │    │
│                     │         │ └──────────────┘    │
│                     │         │                      │
└─────────────────────┘         └──────────────────────┘
```

---

## ⚡ Performance Metrics

```
┌────────────────────────────────────────────┐
│   Component Performance Targets            │
│                                            │
│  Idle Monitoring:                          │
│  │ Polling Interval: 2 seconds             │
│  │ CPU Usage: <1%                          │
│  │ Memory: <20 MB                          │
│  │                                         │
│  Payment Request:                          │
│  │ Time to UI: <100ms                      │
│  │ Total latency: <2 seconds               │
│  │                                         │
│  Face ID Processing:                       │
│  │ Time to result: varies (2-5 sec user)  │
│  │ iPhone processing: <500ms               │
│  │                                         │
│  Screensaver Unlock:                       │
│  │ Time to unlock: <500ms                  │
│  │ Event posting: <100ms                   │
│  │                                         │
│  App Launch:                               │
│  │ Time to menu bar: <1 second             │
│  │ Memory footprint: ~20-30 MB             │
│  │                                         │
│  Overall Response:                         │
│  │ From click to unlock: 3-6 seconds       │
│  │ (depends on user and network)           │
│                                            │
└────────────────────────────────────────────┘
```

---

## 🔍 Error Handling Flow

```
┌──────────────────────────────────────┐
│   Error Detection & Handling         │
│                                      │
│  Validation Errors:                  │
│  ├─ Apple Pay not available          │
│  │  └─ Show error message            │
│  │  └─ Suggest Wallet setup          │
│  │                                   │
│  ├─ No Accessibility permission      │
│  │  └─ Show error message            │
│  │  └─ Link to Settings              │
│  │                                   │
│  Network Errors:                     │
│  ├─ WiFi disconnected                │
│  │  └─ Time out after 30 seconds     │
│  │  └─ Show timeout message          │
│  │                                   │
│  ├─ Bluetooth lost                   │
│  │  └─ Retry mechanism               │
│  │                                   │
│  Authentication Errors:              │
│  ├─ Face ID failed                   │
│  │  └─ User can retry                │
│  │  └─ Shows failure message         │
│  │                                   │
│  ├─ Face ID cancelled                │
│  │  └─ Return to normal state        │
│  │  └─ No error shown                │
│  │                                   │
│  System Errors:                      │
│  ├─ Screensaver unlock failed        │
│  │  └─ Log error                     │
│  │  └─ Show generic error            │
│  │                                   │
│  └─ IOKit access denied              │
│     └─ Check permissions             │
│     └─ Offer System Preferences      │
│                                      │
└──────────────────────────────────────┘
```

---

This document provides visual understanding of how PhoneUnlocker works at all levels:
- System architecture
- Authentication flow
- Component relationships
- Security model
- Data flow
- Integration points
- Performance characteristics
- Error handling

For more details, see the code documentation and individual component files.
