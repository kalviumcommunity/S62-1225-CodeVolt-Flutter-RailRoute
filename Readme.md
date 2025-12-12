# 🚆 RailRoute: Real-Time Train Tracking App  
## Project Plan Document

---

## 1. Problem Statement & Solution Overview

### **Problem Statement**  
Millions of local trains in India run late every day. Commuters rarely receive accurate real-time delay information, platform changes, or rerouting options. This results in missed connections, wasted time, and stress during peak hours. Existing solutions are often inaccurate, delayed, or not designed for mobile-first usage.

### **Solution Overview**  
Our proposed Flutter + Firebase mobile application offers:

- Real-time train delay updates fetched from a free Indian Railways API  
- Platform alerts and ETA predictions  
- Smart alternate route suggestions  
- User-personalized features like saved/favorite routes  
- Fast and commuter-friendly UI designed for quick access  

Firebase ensures real-time data synchronization and scalable backend support, while Flutter provides consistent performance on both Android and iOS.

---

## 2. Scope & Boundaries

### **In Scope (Sprint Deliverables)**  
- Firebase Authentication (Email/Phone)  
- Integration with Free Indian Railways Live Train API  
- Firestore + Realtime Database setup  
- Core mobile UI screens  
- Favorites (CRUD operations)  
- Delay-based reroute logic  
- Error handling and loading states  
- Complete APK build for testing  

### **Out of Scope (Future Upgrades)**  
- ML-based delay prediction  
- Offline navigation  
- Smartwatch app  
- Ticket booking/payment modules  
- Government-verified NTES/CRIS API integration  

---

## 3. Roles & Responsibilities (3-Member Team)

| **Role** | **Member** | **Responsibilities** |
|---------|-------------|-----------------------|
| Mobile UI Lead | Jessica Shalomin | Flutter UI, navigation, responsiveness, animations |
| Firebase & Backend Lead | R John Robert | Firebase Auth, Firestore schema, Realtime DB, API integration |
| Integration, Testing & Deployment Lead | Karandeep M | State management, API→Firebase sync, QA, APK build |

---

## 4. Sprint Timeline (4 Weeks)

### **Week 1 — Foundation Setup & Design**
- Finalize problem statement & requirements  
- Create wireframes & screen flow  
- Initialize Flutter project  
- Configure Firebase services  
- Test free API providers  
- Define Firestore + Realtime DB schema  

### **Week 2 — Core Development**
- Implement Firebase Authentication  
- Build Home, Search, Favorites, Train Status UI  
- Implement API service  
- Store train status in Realtime DB  
- CRUD operations for favorites  

### **Week 3 — Integration & Testing**
- Real-time listeners (Firebase→UI)  
- Alternative route logic  
- Input validation & error screens  
- Multi-device UI testing  
- Debug API integration  

### **Week 4 — Finalization & Deployment**
- UI polish + micro animations  
- Performance optimization  
- Feature freeze  
- Generate final APK  
- Documentation + demo prep  

---

## 5. MVP (Minimum Viable Product)

### **Authentication**
- Login, Signup, Logout (Firebase Auth)

### **Real-Time Train Tracking**
- Delay information  
- Current station  
- ETA & platform number  
- Timestamped updates pushed to Firebase

### **Live Sync (Firebase Realtime Database)**
- API → Firebase → UI flow  
- Instant front-end updates  

### **Route Suggestions**
- Alternative trains if delay crosses threshold  

### **Favorites**
- Add, remove, and view frequently used routes  

### **APK Build**
- Usable and optimized for commuters  

---

## 6. Functional Requirements

### **User Interactions**
- Users can log in/out  
- Users can search trains or choose favorites  
- Users can view real-time train status  
- Users receive alternate route suggestions  
- Users manage favorite routes  

### **System Behavior**
- Real-time Firebase listeners update UI  
- Sync without refresh  
- User-specific data stored with UID in Firestore  

---

## 7. Non-Functional Requirements

### **Performance**
- Real-time update speed < 1 second  
- Screen transitions < 200ms  

### **Security**
- Firestore rules protect per-user data  
- Firebase Auth manages secure tokens  

### **Reliability**
- App handles slow/missing network gracefully  

### **Usability**
- Minimal taps to view train updates  
- Clean UI optimized for commuters  

### **Scalability**
- Support for 100+ real-time listeners  
- Efficient Firestore queries  

---

## 8. Success Metrics

### **Sprint Completion Metrics**
- MVP features complete  
- Firebase Auth & Firestore error-free  
- APK delivered on time  
- Successful GitHub merge flow  
- Real-time updates shown in demo  

### **User Value Metrics**
- Updates feel instant  
- Alternate route suggestions in < 3 seconds  
- UI rated intuitive by mentors  

---

## 9. Risks & Mitigation

| **Risk** | **Impact** | **Mitigation** |
|----------|------------|----------------|
| Poor Realtime DB structure | Slow integration | Finalize schema in Week 1 |
| Slow UI on low-end devices | Poor demo experience | Optimize rebuilds, preload minimal data |
| Firebase Auth bugs | Login failures | Test with Firebase Emulator |
| Team dependencies | Team delays | Weekly check-ins & branch ownership |

---

## Final Output — Submission Items  
- Project Plan Document  
- Wireframes + Screen Flow  
- Firebase Schema  
- GitHub Repository with commits  
- Final APK  

