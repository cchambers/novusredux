namespace NosXmlParser
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.rtbOutput = new System.Windows.Forms.RichTextBox();
            this.folderBrowserDialog1 = new System.Windows.Forms.FolderBrowserDialog();
            this.btnChooseFolder = new System.Windows.Forms.Button();
            this.tbChosenDirectory = new System.Windows.Forms.TextBox();
            this.btnParseChosenFile = new System.Windows.Forms.Button();
            this.tbChosenFile = new System.Windows.Forms.TextBox();
            this.btnChooseFile = new System.Windows.Forms.Button();
            this.btnParseChosenDirectory = new System.Windows.Forms.Button();
            this.cblbDirectoryFiles = new System.Windows.Forms.CheckedListBox();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.btnCheckAll = new System.Windows.Forms.Button();
            this.rtbData = new System.Windows.Forms.RichTextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // rtbOutput
            // 
            this.rtbOutput.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left)));
            this.rtbOutput.Location = new System.Drawing.Point(378, 33);
            this.rtbOutput.Name = "rtbOutput";
            this.rtbOutput.Size = new System.Drawing.Size(248, 391);
            this.rtbOutput.TabIndex = 0;
            this.rtbOutput.Text = "";
            // 
            // btnChooseFolder
            // 
            this.btnChooseFolder.Location = new System.Drawing.Point(13, 13);
            this.btnChooseFolder.Name = "btnChooseFolder";
            this.btnChooseFolder.Size = new System.Drawing.Size(359, 25);
            this.btnChooseFolder.TabIndex = 1;
            this.btnChooseFolder.Text = "Open Directory";
            this.btnChooseFolder.UseVisualStyleBackColor = true;
            this.btnChooseFolder.Click += new System.EventHandler(this.btnChooseFolder_Click);
            // 
            // tbChosenDirectory
            // 
            this.tbChosenDirectory.Location = new System.Drawing.Point(13, 44);
            this.tbChosenDirectory.Name = "tbChosenDirectory";
            this.tbChosenDirectory.ReadOnly = true;
            this.tbChosenDirectory.Size = new System.Drawing.Size(359, 20);
            this.tbChosenDirectory.TabIndex = 2;
            // 
            // btnParseChosenFile
            // 
            this.btnParseChosenFile.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.btnParseChosenFile.Location = new System.Drawing.Point(12, 399);
            this.btnParseChosenFile.Name = "btnParseChosenFile";
            this.btnParseChosenFile.Size = new System.Drawing.Size(360, 25);
            this.btnParseChosenFile.TabIndex = 3;
            this.btnParseChosenFile.Text = "Parse XML File";
            this.btnParseChosenFile.UseVisualStyleBackColor = true;
            this.btnParseChosenFile.Click += new System.EventHandler(this.btnParseChosenFile_Click);
            // 
            // tbChosenFile
            // 
            this.tbChosenFile.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.tbChosenFile.Location = new System.Drawing.Point(13, 373);
            this.tbChosenFile.Name = "tbChosenFile";
            this.tbChosenFile.ReadOnly = true;
            this.tbChosenFile.Size = new System.Drawing.Size(359, 20);
            this.tbChosenFile.TabIndex = 5;
            // 
            // btnChooseFile
            // 
            this.btnChooseFile.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.btnChooseFile.Location = new System.Drawing.Point(13, 342);
            this.btnChooseFile.Name = "btnChooseFile";
            this.btnChooseFile.Size = new System.Drawing.Size(359, 25);
            this.btnChooseFile.TabIndex = 4;
            this.btnChooseFile.Text = "Choose File";
            this.btnChooseFile.UseVisualStyleBackColor = true;
            this.btnChooseFile.Click += new System.EventHandler(this.btnChooseFile_Click);
            // 
            // btnParseChosenDirectory
            // 
            this.btnParseChosenDirectory.Location = new System.Drawing.Point(94, 70);
            this.btnParseChosenDirectory.Name = "btnParseChosenDirectory";
            this.btnParseChosenDirectory.Size = new System.Drawing.Size(279, 25);
            this.btnParseChosenDirectory.TabIndex = 6;
            this.btnParseChosenDirectory.Text = "Parse XML File";
            this.btnParseChosenDirectory.UseVisualStyleBackColor = true;
            this.btnParseChosenDirectory.Click += new System.EventHandler(this.btnParseChosenDirectory_Click);
            // 
            // cblbDirectoryFiles
            // 
            this.cblbDirectoryFiles.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left)));
            this.cblbDirectoryFiles.FormattingEnabled = true;
            this.cblbDirectoryFiles.Location = new System.Drawing.Point(13, 102);
            this.cblbDirectoryFiles.Name = "cblbDirectoryFiles";
            this.cblbDirectoryFiles.Size = new System.Drawing.Size(359, 229);
            this.cblbDirectoryFiles.TabIndex = 7;
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            this.openFileDialog1.InitialDirectory = "C:\\Users\\berycs_v2\\Desktop\\novusredux-master\\mods\\NOS\\templates\\mobiles";
            // 
            // btnCheckAll
            // 
            this.btnCheckAll.Location = new System.Drawing.Point(12, 71);
            this.btnCheckAll.Name = "btnCheckAll";
            this.btnCheckAll.Size = new System.Drawing.Size(76, 25);
            this.btnCheckAll.TabIndex = 8;
            this.btnCheckAll.Text = "Check All";
            this.btnCheckAll.UseVisualStyleBackColor = true;
            this.btnCheckAll.Click += new System.EventHandler(this.btnCheckAll_Click);
            // 
            // rtbData
            // 
            this.rtbData.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.rtbData.Location = new System.Drawing.Point(632, 33);
            this.rtbData.Name = "rtbData";
            this.rtbData.Size = new System.Drawing.Size(312, 391);
            this.rtbData.TabIndex = 9;
            this.rtbData.Text = "";
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(632, 13);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(485, 17);
            this.label1.TabIndex = 10;
            this.label1.Text = "Data Output";
            // 
            // label2
            // 
            this.label2.Location = new System.Drawing.Point(378, 9);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(248, 17);
            this.label2.TabIndex = 11;
            this.label2.Text = "Random Notes";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(956, 436);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.rtbData);
            this.Controls.Add(this.btnCheckAll);
            this.Controls.Add(this.cblbDirectoryFiles);
            this.Controls.Add(this.btnParseChosenDirectory);
            this.Controls.Add(this.tbChosenFile);
            this.Controls.Add(this.btnChooseFile);
            this.Controls.Add(this.btnParseChosenFile);
            this.Controls.Add(this.tbChosenDirectory);
            this.Controls.Add(this.btnChooseFolder);
            this.Controls.Add(this.rtbOutput);
            this.Name = "Form1";
            this.Text = "NOS Xml Parser";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.RichTextBox rtbOutput;
        private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog1;
        private System.Windows.Forms.Button btnChooseFolder;
        private System.Windows.Forms.TextBox tbChosenDirectory;
        private System.Windows.Forms.Button btnParseChosenFile;
        private System.Windows.Forms.TextBox tbChosenFile;
        private System.Windows.Forms.Button btnChooseFile;
        private System.Windows.Forms.Button btnParseChosenDirectory;
        private System.Windows.Forms.CheckedListBox cblbDirectoryFiles;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.Button btnCheckAll;
        private System.Windows.Forms.RichTextBox rtbData;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
    }
}

