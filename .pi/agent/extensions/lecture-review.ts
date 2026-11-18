import { type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

export default function (pi: ExtensionAPI) {
  // Helper: build the skill invocation message
  function buildSkillMessage(subcommand: string, lecturePath: string, extraArgs: string = ""): string {
    let msg = `/skill:lecture-review ${subcommand} ${lecturePath}`;
    if (extraArgs) {
      msg += ` ${extraArgs}`;
    }
    return msg;
  }

  // --- create command ---
  pi.registerCommand("lecture-review create", {
    description: "Generate an active-recall review file from lecture slides",
    parameters: Type.Object({
      lecturePath: Type.String({ description: "Path to the lecture Markdown file" }),
      lectureCode: Type.Optional(Type.String({ description: "Lecture code/number (e.g., 'CS101', 'ML03'). Used for output filename." })),
      lectureName: Type.Optional(Type.String({ description: "Lecture title. Used for output filename. Defaults to filename without extension." })),
    }),
    handler: async (args, ctx) => {
      const extraArgs: string[] = [];
      if (args.lectureCode) extraArgs.push(`--code ${args.lectureCode}`);
      if (args.lectureName) extraArgs.push(`--name ${args.lectureName}`);
      const msg = buildSkillMessage("create", args.lecturePath, extraArgs.join(" "));
      ctx.ui.notify(`Generating review file...`, "info");
      await ctx.sendUserMessage(msg, { triggerTurn: true });
    },
  });

  // --- check command ---
  pi.registerCommand("lecture-review check", {
    description: "Check your filled review against the original slides and identify gaps",
    parameters: Type.Object({
      lecturePath: Type.String({ description: "Path to the lecture Markdown file" }),
      reviewPath: Type.String({ description: "Path to your filled active-recall review file" }),
    }),
    handler: async (args, ctx) => {
      const msg = `/skill:lecture-review check ${args.lecturePath} ${args.reviewPath}`;
      ctx.ui.notify(`Checking your review...`, "info");
      await ctx.sendUserMessage(msg, { triggerTurn: true });
    },
  });

  // --- test command ---
  pi.registerCommand("lecture-review test", {
    description: "Generate self-test questions from lecture slides, or grade your answers",
    parameters: Type.Object({
      lecturePath: Type.String({ description: "Path to the lecture Markdown file" }),
      questions: Type.Optional(Type.Number({ description: "Number of questions to generate (default: 10)" })),
      grade: Type.Optional(Type.Boolean({ description: "If true, grade your answers instead of generating questions" })),
      testPath: Type.Optional(Type.String({ description: "Path to your self-test file (required when grading)" })),
    }),
    handler: async (args, ctx) => {
      const extraArgs: string[] = [];
      if (args.questions) extraArgs.push(`--questions ${args.questions}`);
      if (args.grade) extraArgs.push("--grade");
      if (args.testPath) extraArgs.push(args.testPath);
      const msg = buildSkillMessage("test", args.lecturePath, extraArgs.join(" "));
      ctx.ui.notify(args.grade ? `Grading your answers...` : `Generating questions...`, "info");
      await ctx.sendUserMessage(msg, { triggerTurn: true });
    },
  });

  // --- explain command ---
  pi.registerCommand("lecture-review explain", {
    description: "Explain a concept from the lecture that you don't fully understand",
    parameters: Type.Object({
      lecturePath: Type.String({ description: "Path to the lecture Markdown file" }),
      topic: Type.String({ description: "The section or concept you want explained (e.g., 'Section 3.2', 'dynamic programming' )" }),
    }),
    handler: async (args, ctx) => {
      const msg = `/skill:lecture-review explain ${args.lecturePath} --topic "${args.topic}"`;
      ctx.ui.notify(`Explaining "${args.topic}"...`, "info");
      await ctx.sendUserMessage(msg, { triggerTurn: true });
    },
  });

  // --- quick-review command ---
  pi.registerCommand("lecture-review quick-review", {
    description: "Fast 2-3 minute review of a previous lecture before attending the next class",
    parameters: Type.Object({
      lecturePath: Type.String({ description: "Path to the previous lecture's Markdown file (or review file)" }),
      nextLectureTopic: Type.Optional(Type.String({ description: "Next lecture topic (optional). Used to create a connection between lectures." })),
    }),
    handler: async (args, ctx) => {
      const extraArgs: string[] = [];
      if (args.nextLectureTopic) extraArgs.push(`--next-topic "${args.nextLectureTopic}"`);
      const msg = buildSkillMessage("quick-review", args.lecturePath, extraArgs.join(" "));
      ctx.ui.notify(`Quick review in 2-3 minutes...`, "info");
      await ctx.sendUserMessage(msg, { triggerTurn: true });
    },
  });
}
