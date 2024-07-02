using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace P01_StudentSystem.Data.Models
{
    public class Resource
    {
        public int ResourceId { get; set; }

        [StringLength(50)]
        [Required]
        public string Name { get; set; } = null!;

        [Column(TypeName = "VARCHAR")]
        [Required]
        public string Url { get; set; }

        [Required]
        public ResourceType ResourceType { get; set; }

        [Required]
        public int CourseId { get; set; }

        [ForeignKey(nameof(CourseId))]
        public virtual Course Course { get; set; }
    }
    public enum ResourceType
    {
        Video,
        Presentation,
        Document,
        Other
    }
}
