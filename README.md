# ProctorAI – AI-Powered Online Examination Proctoring Platform

**Full-stack real-time AI examination proctoring web application with React, Vite, TypeScript, Tailwind CSS, FastAPI, OpenCV, MediaPipe, and YOLOv8.**

ProctorAI provides a modern, dark SaaS web interface integrated directly with the computer-vision engine to continuously observe the visible exam environment, capture high-resolution screenshot evidence, record complete examination sessions to MP4, and generate downloadable PDF audit reports.

---

## Quick Start (Web Platform)

Double-click start_proctorai.bat or run:

`ash
# 1. Activate environment
.\venv\Scripts\activate

# 2. Launch FastAPI Server & Unified Web Application
python backend\run_backend.py
`

Open your browser to:
**http://localhost:8000**

---

## Standalone CLI Mode (Original Engine)

You can still run the engine directly from terminal with OpenCV GUI:

`ash
.\venv\Scripts\activate
python main.py
`

---

# AI-Proctor

**Real-time AI exam proctoring system using Python, OpenCV, MediaPipe and YOLO for face, gaze, head pose, hand, object, lighting and camera-frame monitoring.**

AI-Proctor is a standalone computer-vision-based exam proctoring prototype that uses a laptop webcam to continuously observe the visible exam environment and generate real-time warnings when predefined visual conditions are detected.

The system is designed as a **camera-only proctoring prototype**. It does not determine whether a candidate has cheated; instead, it detects potentially relevant visual events and preserves them for later human review.

---

## Features

### Face monitoring
- Detects whether a candidate's face is visible.
- Detects when no face is visible for a sustained period.
- Detects multiple faces in the camera frame.

### Head-pose monitoring
- Estimates head orientation using facial landmarks and head-pose estimation.
- Detects head turned left, head turned right, looking up, and looking down.

### Gaze monitoring
- Estimates horizontal and vertical eye-gaze position using facial and iris landmarks.
- Generates a warning when gaze moves sufficiently away from the calibrated screen-facing position.

### Hand detection
- Detects hands entering the camera frame.
- Hand presence is treated as a separate proctoring event from generic object detection.

### Generic object detection
- Uses a pretrained YOLO model to detect objects other than the candidate.
- The system intentionally does not make a final judgment about what the object means for the examination.
- The detected frame can be preserved as visual evidence for later human review.

### Lighting monitoring
- Monitors overall frame brightness.
- Generates a low-light warning when the camera environment remains below the configured brightness threshold.

### Candidate framing
- Uses MediaPipe Pose Landmarker to evaluate whether the candidate is sufficiently positioned within the camera frame.
- Checks face size, shoulder visibility, shoulder span, visible area below the shoulders, and excessive camera zoom.

### Camera movement
- Includes an experimental camera-movement detector based on optical-flow analysis.
- It attempts to identify large-scale movement across the camera frame that may indicate that the camera itself was repositioned.

### Real-time warning system
Multiple warnings can be active at the same time.

Example:

```text
PROCTORING WARNINGS

- Head turned right
- Gaze away from screen
- Hand detected
- Object detected
```

### Risk indication
The application maintains an initial risk index based on configured event weights. The score is intended as an indicator for human review, not as an automated cheating decision.

### Recording
The complete camera session is recorded as an MP4 file.

### Event logging
Detected events are recorded in a timestamped TXT file with event start/end times, durations and occurrence information.

### Evidence screenshots
A screenshot is captured when a tracked event starts.

Evidence files are stored using the event timestamp and event name, for example:

```text
00-02-14_hand_detected.jpg
00-05-37_head_turned_right.jpg
00-08-21_object_detected.jpg
```

---

## How It Works

```text
                 Laptop Webcam
                       |
                       v
              +------------------+
              |    AI-Proctor    |
              +------------------+
                       |
       +---------------+---------------+
       |               |               |
       v               v               v
     Face            Head            Gaze
   Analysis         Pose           Analysis
       |               |               |
       +---------------+---------------+
                       |
             +---------+---------+
             |                   |
             v                   v
          Hands              Objects
        Detection           Detection
             |                   |
             +---------+---------+
                       |
             +---------+---------+
             |                   |
             v                   v
        Low-Light           Framing /
        Analysis             Camera Motion
             |                   |
             +---------+---------+
                       |
                       v
              Event / Warning
                       |
             +---------+---------+
             |                   |
             v                   v
        Live Warning         Evidence
                              Screenshot
                       |
             +---------+---------+
             |                   |
             v                   v
          MP4 Video          TXT Log
```

---

## Technologies

- **Python**
- **OpenCV** — camera capture, image processing, video recording and optical-flow analysis
- **MediaPipe Tasks** — face landmarks, hand landmarks and pose landmarks
- **Ultralytics YOLO26** — pretrained object detection
- **NumPy** — numerical processing

MediaPipe's Python Tasks Vision API provides the Face Landmarker, Hand Landmarker and Pose Landmarker used by this project.

[MediaPipe Tasks Vision API](https://ai.google.dev/edge/api/mediapipe/python/mp/tasks/vision)

The project currently uses the pretrained `yolo26n.pt` detection model through Ultralytics.

[Ultralytics YOLO26 documentation](https://docs.ultralytics.com/models/yolo26)

---

## Project Structure

Recommended local structure:

```text
AI-Proctor/
│
├── main.py
├── requirements.txt
├── yolo26n.pt
│
├── models/
│   ├── face_landmarker.task
│   ├── hand_landmarker.task
│   └── pose_landmarker_full.task
│
└── recordings/
    └── exam_YYYY-MM-DD_HH-MM-SS/
        ├── exam_YYYY-MM-DD_HH-MM-SS.mp4
        ├── exam_YYYY-MM-DD_HH-MM-SS.txt
        └── evidence/
            ├── 00-02-14_hand_detected.jpg
            ├── 00-05-37_head_turned_right.jpg
            └── ...
```

The `recordings/` directory is generated by the application.

---

If PowerShell prevents script execution, Command Prompt can be used:

```cmd
venv\Scripts\activate.bat
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

---

## MediaPipe Models

The application expects three MediaPipe `.task` model files in the `models/` directory.

### Face Landmarker

Download:

https://storage.googleapis.com/mediapipe-models/face_landmarker/face_landmarker/float16/1/face_landmarker.task

Place it at:

```text
models/face_landmarker.task
```

### Hand Landmarker

Download:

https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task

Place it at:

```text
models/hand_landmarker.task
```

### Pose Landmarker

Download:

https://storage.googleapis.com/mediapipe-models/pose_landmarker/pose_landmarker_full/float16/1/pose_landmarker_full.task

Place it at:

```text
models/pose_landmarker_full.task
```

---

## YOLO Model

The application uses:

```text
yolo26n.pt
```

Ultralytics can download the pretrained YOLO26n model automatically when it is loaded for the first time:

```python
from ultralytics import YOLO

model = YOLO("yolo26n.pt")
```

See the official documentation for the current YOLO26 model and licensing information:

https://docs.ultralytics.com/models/yolo26

---

## Running the Project

Once the required MediaPipe models are in place:

```bash
python main.py
```

The webcam window will open and AI-Proctor will begin real-time monitoring.

Press:

```text
Q
```

to stop the session.

---

## Session Output

After the program stops, a session directory is created under:

```text
recordings/
```

For example:

```text
recordings/
└── exam_2026-08-23_18-26-58/
```

Inside it:

```text
exam_2026-08-23_18-26-58.mp4
exam_2026-08-23_18-26-58.txt
evidence/
```

### Video

The MP4 contains the recorded camera session.

### Event log

The TXT file contains timestamped events such as:

```text
00:02:14  Hand detected - START | Evidence: evidence/00-02-14_hand_detected.jpg
00:02:18  Hand detected - END (Duration: 00:00:04)

00:05:37  Head turned right - START | Evidence: evidence/00-05-37_head_turned_right.jpg
00:05:41  Head turned right - END (Duration: 00:00:04)
```

### Evidence

The evidence directory contains screenshots captured at the beginning of tracked events.

This allows a reviewer to quickly inspect the visual context of an event without manually searching through the entire recording.

---

## Detection Events

The current system can generate warnings for:

```text
Face not detected
Multiple faces detected

Head turned left
Head turned right
Looking up
Looking down

Gaze away from screen

Hand detected
Object detected

Low light

Candidate not properly positioned

Camera movement detected
```

Multiple events can be active simultaneously.

---

## What This Project Does Not Do

AI-Proctor is intentionally designed as a **visual event detection and assistance system**, not an autonomous cheating judge.

It currently does not:

- Determine whether a candidate cheated
- Perform speech recognition
- Analyze microphone audio
- Monitor other applications
- Monitor browser tabs
- Monitor the candidate's screen
- Integrate with an examination platform
- Identify a specific object as cheating evidence
- Make a final disciplinary decision

The purpose is to detect and preserve potentially relevant visual events so that a human can review them.

---

## Limitations

Computer vision is not perfect.

Detection performance can be affected by:

- Camera quality
- Lighting
- Camera placement
- Background conditions
- Face orientation
- Occlusion
- Distance from the camera
- Individual differences in appearance
- Model limitations

Gaze estimation and camera-movement detection are particularly sensitive to camera conditions and may require threshold tuning for different hardware.

The system should therefore be considered a **prototype for AI-assisted visual proctoring**, not a replacement for human judgment.

---

## Future Scope

Potential future integration could include:

- Integration with an examination platform
- Exam-session start/stop events supplied by the platform
- Reviewer-facing interfaces
- More advanced event analysis
- Additional deployment and scalability options

These are outside the scope of the current standalone camera-based prototype.

---

## Responsible Use

This project is intended for experimentation, learning and research into computer vision and AI-assisted exam proctoring.

Any real-world deployment involving students or candidates should consider privacy, consent, data retention, accessibility, false positives, security and applicable laws or institutional policies.

---

## License and Third-Party Components

This repository does not currently declare a project-level open-source license.

Third-party libraries and pretrained model assets used by the project remain subject to their respective licenses and terms.

In particular, review the licensing terms of Ultralytics and the model assets before using this project in commercial or other production environments.

---

## Author

**Nirant07**

Built as a standalone computer-vision project exploring real-time AI-assisted exam proctoring using a laptop webcam.
