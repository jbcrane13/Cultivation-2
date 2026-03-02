# Product Requirements Document: "Cultivation"
Version: 1.1 (Agent/Dev Handoff Ready)
Target Platform: iOS/iPadOS (Native)
1. ### Product Vision & Value Proposition
Cultivation is a premium, iOS-native gardening application designed to feel like a first-party Apple app. It bridges the gap between digital planning and physical gardening by utilizing Apple's native frameworks (ARKit, Vision, CoreML, WeatherKit).
Mission: To eliminate the guesswork of gardening by combining hyper-local climate data, visual AR mapping, and AI diagnostics into an intuitive, glassmorphic UI.

2. ### Technical Stack & Architecture
Agents and developers must strictly adhere to this native Apple stack. Cross-platform frameworks (React Native, Flutter) are explicitly forbidden.
* UI Framework: SwiftUI
* Local Database: SwiftData (for offline-first capability)
* Cloud Sync: CloudKit (seamless sync across iPhone and iPad)
* Machine Learning: CoreML & Vision (for on-device plant identification and disease detection)
* Augmented Reality: ARKit & RealityKit (for garden boundary mapping and "X-Ray" vision)
* Weather & Climate: Apple WeatherKit (for hyper-local precipitation and sun data)
* Haptics: UIImpactFeedbackGenerator (required for drag-and-drop and button state changes)
3. ### Data Models (Schema Outline)
Agents should use these core entities when building the SwiftData schema:
 * User: id, experienceLevel (enum), hardinessZone, petSafeModeEnabled (bool), locationCoordinates.
 * GardenBed: id, name, type (enum: indoor, raisedBed, greenhouse), arAnchorID (UUID mapping to physical space), sunExposureLevel.
 * Plant: id, species, commonName, isPetSafe (bool), waterFrequencyDays, sunRequirement, datePlanted.
 * Task: id, plantID, taskType (enum: water, fertilize, prune, harvest), dueDate, isCompleted (bool).
4. ### Epic & User Story Breakdown
#### Epic 1: Onboarding & Profile Generation
* Story 1.1: As a user, I want to select my experience level so the app tailors its care advice (e.g., hiding pH balance metrics from beginners).
* Story 1.2: As a user, I need the app to request Location permissions so it can calculate my hardiness zone and connect to WeatherKit.
* Story 1.3: As a user with Boykin Spaniels, I want a "Pet-Safe Mode" toggle during onboarding that permanently filters or flags plants toxic to dogs.
#### Epic 2: The AR "X-Ray" Garden Layout (Core Differentiator)
* Story 2.1: As a user, I want to open my camera and use ARKit to drop pins on the corners of my raised beds to define the physical boundaries.
* Story 2.2: As a user, I want to drag and drop digital seed packets into this AR space.
* Story 2.3: As a user, I want to point my phone at the dirt weeks later and see an AR overlay showing me what is planted there, the root depth, and the estimated sprout date.
#### Epic 3: AI Scanner & Diagnostic Tool
* Story 3.1: As a user, I want to point my camera at an unknown plant and have Vision/CoreML identify the species instantly.
* Story 3.2: As a user, I want to scan a yellowing leaf and receive a diagnostic report (e.g., "Overwatered" or "Nitrogen Deficiency") with actionable steps.
* Story 3.3: Offline Requirement: The base ML identification model must work without cellular service (useful deep in nurseries or rural gardens).
#### Epic 4: The Adaptive Care Engine
* Story 4.1: As a user, I want a daily dashboard showing me what tasks to complete (Watering, Pruning).
* Story 4.2: As a user in Daphne, AL (Zone 8b), if WeatherKit predicts heavy rain tomorrow, I want the app to automatically cancel my manual outdoor watering tasks for the next 3 days.
5. ### UI/UX & Design Guidelines (HIG Compliance)
* Visual Style: Glassmorphic. Heavy use of .ultraThinMaterial for cards over lush, green photographic backgrounds or soft gradients.
* Typography: SF Pro Rounded for primary headers to evoke a friendly, organic feel. SF Pro Text for body copy.
* Colors: Dark Mode must be supported natively. Primary accent color should be a vibrant, natural green (e.g., #28CD41).
* Empty States: Must be delightful. An empty garden should show a beautiful illustration of an empty pot with a call-to-action to "Scan your first plant."
6. QA & Testing Strategy (Apple/Walmart Grade)
Given the heavy reliance on hardware sensors, the QA process must be rigorous and test beyond the simulator.
#### 6.1. ARKit & Spatial Testing
* AR Drift: Test the "X-Ray" feature over time. Drop an AR seed anchor, close the app, and return 48 hours later under different lighting conditions (e.g., morning dew vs. harsh midday sun) to ensure the anchor hasn't shifted coordinates.
* Boundary Edge Cases: What happens if a user tries to place a digital plant outside the mapped AR bed? The app should provide gentle haptic feedback and a visual bounce animation rejecting the placement.
6.2. WeatherKit Logic Testing (API Mocking)
 * Time-Shifting: Inject mock WeatherKit JSON responses simulating a sudden Gulf Coast summer downpour. Verify that the Task database immediately recalculates and suppresses outdoor watering reminders.
 * Zone Boundary Testing: Test zip codes right on the border of hardiness zones (e.g., between Zone 8b and 9a) to ensure correct frost-date logic is applied.
#### 6.3. ML Vision Testing
* False Positives: Test the disease scanner against healthy plants with natural variegation (like a Thai Constellation Monstera) to ensure it doesn't falsely diagnose it as a virus.
* Pet-Safe Flagging: Present the camera with a Sago Palm (highly toxic to dogs). Verify that the Pet-Safe alert interrupts the UI immediately upon detection to protect pets like Julep and Koda.
#### 6.4. Hardware Constraints
* Thermal Throttling: Running ARKit and CoreML simultaneously generates heat. Test on older devices (e.g., iPhone 12) to ensure the frame rate stays above 30fps and the device doesn't aggressively dim the screen.
