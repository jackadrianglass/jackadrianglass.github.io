The Plan:
The idea is to largely base the website off of one that I found
[here](https://jekyll-theme-minimal-resume.netlify.app/)

# Deploy

- [ ] Merge the elm-website branch into mainline
- [ ] Setup a seperate branch for deployments so that github pages can be pointed to it
- [ ] Setup a github action to pull the latest and greatest of mainline and build it

# Main Page

- [ ] Port all of the elm-ui stuff to just CSS (just learn it. elm-ui is just a little too limiting)

- [x] Creative Coding Splash Screen
- [ ] Link Tree
    - [ ] Have each link be little bubbles
    - [ ] Each bubble should react when the user hovers over it
    - [ ] Your name should be the most prominent thing
    - [ ] Investigate which font you want to use
- [ ] Brief Section
    - [ ] Head Shot
    - [ ] About Yourself
    - [ ] Contact Information (should be covered by your link tree. Maybe the redundancy is useful)
- [ ] Skill List
    - Split by technology
    - Probably have some images around each technology used
    - Brief description of the projects involved
- [ ] Work Experience
    - [ ] Timeline view (which is just a stylized list)
    - [ ] Link to every office that you've worked at
    - [ ] Link to every project if there's a product link
    - [ ] Garmin
        - [ ] Summer Student (BLE team)
        - [ ] Internship (fatcat, rally ble revamp)
        - [ ] Full time (helios & spek)
    - [ ] Lockheed Skunkworks
        - [ ] Platform team
        - [ ] Martian team
        - [ ] Devops team
    - [ ] Big Geo!!!
    - Reverse chronological order
- [ ] Side Projects
    - [ ] Cards for each
        - Gif demo of each or just a little picture (it would be sweet if the gif would play when you hover over it)
        - Link to the github repo
        - Little language styles at the bottom
        - Description of what it is
        - A little indicator whether it's a WIP
    - [ ] Git repo needs to be split from the collection repos that you have
    - [ ] Shout out byte club somewhere
    - [ ] Include this website
    - [ ] Beat generator CLI
    - [ ] Creative coding stuff
    - [ ] Some of your graphics stuff from university

# Creative Coding

- [x] Tiled Lines
    - [x] Have it sizeable to a different width than height
    - [x] Inject a color scheme into it
    - [x] Make it the splash screen of the main page
    - [x] Handle resize events (which probably just means redraw it?)
- [ ] Find some other creative coding ideas to work on

# Notes

## Theming and CSS

Most themes are based on some CSS variables that change when you set a particular
class or attribute on an element. Then everything else responds to that particular
change.

[Reference for design thoughts](https://www.youtube.com/watch?v=JbxKTBvSLeY)

So building this out will be to create
- Some basic design tokens
- Basic design components that reference the design tokens
- Build the pages out of the components
