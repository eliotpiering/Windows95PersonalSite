defmodule PersonalSiteWeb.DesktopLiveView do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(PersonalSiteWeb.DesktopView, "index.html", assigns)
  end

  def mount(%{user_id: user_id}, socket) do
    case {:ok, 40} do
      {:ok, temperature} ->
        {:ok, assign(socket, temperature: temperature, user_id: user_id, open_objs: %{})}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def handle_event("open_obj", value, socket) do
    new_folder = Map.merge(initial_position(), folder_lookup(value["slug"]))
    new_folders = socket.assigns.open_objs |> Map.put(value["slug"], new_folder)
    {:noreply, assign(socket, open_objs: new_folders)}
  end

  def handle_event("close", value, socket) do
    new_folders = socket.assigns.open_objs |> Map.delete(value["slug"])
    {:noreply, assign(socket, open_objs: new_folders)}
  end

  def handle_event("card_window_moved", value, socket) do
    moved_folder = Map.merge(%{x: value["x"], y: value["y"]}, folder_lookup(value["slug"]))
    new_folders = socket.assigns.open_objs |> Map.put(value["slug"], moved_folder)
    {:noreply, assign(socket, open_objs: new_folders)}
  end

  defp initial_position() do
    %{x: 0, y: 0}
  end

  #TODO break this out to its own module with access methods and %nolder
  defp folder_lookup(slug) do
    case slug do
      "fun_projects" ->
        %PersonalSite.Folder{title: "Fun Projects", description: "Some of my past projects. Collection of partially finished ideas, games and other side projects I worked on -- mostly to learn new things."}
      "work_projects" ->
        %PersonalSite.Folder{title: "Work Projects", description: "Some descriptions of Actual Projects I've worked on.  Its a little slice of my Resume.  You can also just check out my actual resume"}
      "resume" ->
        %PersonalSite.TextFile{title: "Resume", contents: ~s"""
    <div class="container">
        <h1>Eliot Piering</h1>

<h2>Software Developer</h2>

<button class='btn btn-primary'>Download PDF Version of this Resume</button>

<blockquote>
  <p><a href="eliot@eliotpiering.com">eliot@eliotpiering.com</a><br />
  (617) 943-5514</p>
</blockquote>

<hr />

<h3 id="profile">Profile</h3>

<p>Experienced full-stack developer specializing in Ruby and JavaScript. Versatile, practical, and a good teammate. I take pride in writing quality readable code, using the right tools for the job, and developing solutions for the end user first.</p>

<hr />

<h3 id="skills">Skills</h3>

<ul>
<li><dl>
<dt>Languages</dt>
<dd>Ruby, JavaScript, Elixir, Elm</dd>
</dl></li>
<li><dl>
<dt>Frameworks</dt>
<dd>Rails, Ember, Phoenix</dd>
</dl></li>
<li><dl>
<dt>Other Skills and Tools</dt>
<dd>Linux, AWS, Git, MySQL</dd>
</dl></li>
</ul>

<hr />

<h3 id="experience">Experience</h3>

<dl>
<dt>KnowInk</dt>
<dd><em>Software Developer</em><br />
<strong>October 2017 - October 2019</strong></dd>
</dl>

<ul>
<li>Lead Developer of ePulse, a Ruby on Rails app that serves as KnowInk&#8217;s control center for managing elections.</li>
<li>Wrote and designed API&#8217;s for our iOS app that poll workers used during elections and early voting periods. The api handled capturing voter check-ins, creating and updating voter registrations, canceling check-ins, sending and capturing signatures, printing ballots, spoiling ballots, and various other state specific election tasks.</li>
<li>Developed a reactive user interface using Rails, JavaScript and CSS that enabled election officials to import, view and manage their voter data, election day inventory, and address any issues arising during early voting or on election day.</li>
<li>Implemented robust reporting capabilities using lots of ActiveRecord and raw SQL that clients used to view vital data check points pre and post election.</li>
<li>Integrated with a wide collection of third party Voter Registration systems.</li>
<li>Engaged closely with clients to plan work and offer creative solutions for achieving any desired election day flows.</li>
</ul>
<br/>

<dl>
<dt>LaunchCode</dt>
<dd><em>Software Developer</em><br />
<strong>April 2015 - May 2017</strong></dd>
</dl>

<ul>
<li>Contributed to LaunchCode’s core Ruby on Rails web application that enabled LaunchCode to evaluate potential candidates for apprenticeship programs, enroll students in education programs, and provides tailored administrator interface to manage users throughout the enrollment process.</li>
<li>Tech lead on internal platform built using JavaScript and Ember that allows business development team to cultivate contacts with companies, search for qualified candidates, match candidates with open jobs, and track progress throughout the apprenticeship.</li>
<li>Created, automated and maintained LaunchCode’s infrastructure that powers various business tools and education systems. Utilized Amazon Web Services, shell scripts, and monitoring tools to provide consistent, stable and safely modifiable infrastructure.</li>
<li>Collaborated on the creation of internal agile processes, instituting regular feedback loops, project planning/estimating, and code reviews ensuring high quality code that provides effective business solutions.</li>
</ul>
<br/>

<dl>
<dt>Radialogica</dt>
<dd><em>Software Developer</em><br />
<strong>October 2013 - April 2015</strong></dd>
</dl>

<ul>
<li>Built web software using Ruby on Rails and JavaScript with Ember that enabled secure file sharing and organization management.</li>
<li>Developed cloud infrastructure using Docker and CoreOS, ensuring scalability, automation, security, while remaining HIPPA compliant.</li>
<li>Mentored and onboarded new team members into the web project enabling them to make meaningful contributions shortly after joining the team.</li>
</ul>
<br/>

<hr />

<h3 id="education">Education</h3>

<p>Washington University in St. Louis
<strong>June 2012 - May 2016</strong></p>

<ul>
<li>B.S. in Psychology and Economics</li>
<li>Graduated Magma Cum Laude in Psychology</li>
</ul>

<hr />

<h3 id="interests">Interests</h3>

<ul>
<li>Work on various programming side project for fun and learning. Currently I’m building a &#8220;sonos clone&#8221; using Elixir.</li>
<li>Play the drums and piano and love to play in casual bands.</li>
</ul>

<hr />

<h3 id="footer">Footer</h3>

<p>Eliot Piering &#8212; <a href="eliot@eliotpiering.com">eliot@eliotpiering.com</a> &#8212; (617) 943-5514</p>

<hr />
</div>
"""




}

      _ ->
        %PersonalSite.Folder{title: "Unknown", description: "???"}
    end
  end
end
